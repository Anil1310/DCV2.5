
package com.divineclasses.portal;

import android.Manifest;
import android.content.Intent;
import android.content.ContentValues;
import android.content.pm.PackageManager;
import android.content.ActivityNotFoundException;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.graphics.Typeface;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.speech.RecognizerIntent;
import android.webkit.PermissionRequest;
import android.view.Gravity;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient.FileChooserParams;
import android.webkit.WebChromeClient;
import android.webkit.JavascriptInterface;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebSettings;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.activity.ComponentActivity;
import androidx.core.splashscreen.SplashScreen;

import org.json.JSONObject;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public final class MainActivity extends ComponentActivity {
    private static final String APP_URL = "https://script.google.com/macros/s/AKfycbzlbJUklVvhuJzIDoWv3a3CXY4trX435BiGD1JGIOeuYJC7PiR5lqI15Ymz0kFEpf0P/exec";
    private static final Set<String> APP_HOSTS = new HashSet<>(Arrays.asList(
            "script.google.com",
            "accounts.google.com"));
    private static final int BLUE = Color.rgb(25, 55, 190);

    private WebView webView;
    private FrameLayout appRoot;
    private View loadingScreen;
    private View offlineScreen;
    private ProgressBar loadingProgressBar;
    private TextView loadingProgressLabel;
    private ConnectivityManager connectivityManager;
    private ConnectivityManager.NetworkCallback networkCallback;
    private boolean networkCallbackRegistered;
    private boolean internetAvailable;
    private boolean pageLoaded;
    private boolean portalLoadFailed;
    private boolean portalLoadInProgress;
    private boolean appReadySignaled;
    private Runnable loadingFallbackRunnable;
    private final Handler mainHandler = new Handler(Looper.getMainLooper());
    private ActivityResultLauncher<Intent> speechRecognitionLauncher;
    private ActivityResultLauncher<String> microphonePermissionLauncher;
    private ActivityResultLauncher<String> cameraPermissionLauncher;
    private ActivityResultLauncher<String> locationPermissionLauncher;
    private ActivityResultLauncher<String[]> appPermissionsLauncher;
    private ActivityResultLauncher<Intent> photoChooserLauncher;
    private PermissionRequest pendingCameraRequest;
    private PermissionRequest pendingWebPermissionRequest;
    private String pendingGeolocationOrigin;
    private android.webkit.GeolocationPermissions.Callback pendingGeolocationCallback;
    private ValueCallback<Uri[]> pendingFileChooser;
    private FileChooserParams pendingFileChooserParams;
    private Uri pendingCameraPhotoUri;
    private boolean voiceRequestCancelled;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        SplashScreen.installSplashScreen(this);
        super.onCreate(savedInstanceState);
        microphonePermissionLauncher = registerForActivityResult(
                new ActivityResultContracts.RequestPermission(),
                granted -> {
                    if (granted && !voiceRequestCancelled) {
                        startNativeSpeechRecognition();
                    } else if (!granted) {
                        sendVoiceMessage("error", "permission", "");
                    }
                });
        cameraPermissionLauncher = registerForActivityResult(
                new ActivityResultContracts.RequestPermission(),
                granted -> {
                    PermissionRequest request = pendingCameraRequest;
                    pendingCameraRequest = null;
                    if (request != null) {
                        if (granted && request.getOrigin() != null &&
                                isAppHost(request.getOrigin().getHost())) {
                            request.grant(new String[] { PermissionRequest.RESOURCE_VIDEO_CAPTURE });
                        } else {
                            request.deny();
                        }
                        return;
                    }
                    if (pendingFileChooser != null && pendingFileChooserParams != null) {
                        FileChooserParams params = pendingFileChooserParams;
                        pendingFileChooserParams = null;
                        launchPhotoChooser(params, granted);
                    }
                });
        locationPermissionLauncher = registerForActivityResult(
                new ActivityResultContracts.RequestPermission(),
                granted -> {
                    // Location permission granted/denied for WebView geolocation
                    // The WebView will re-evaluate geolocation on next page load or request
                });
        appPermissionsLauncher = registerForActivityResult(
                new ActivityResultContracts.RequestMultiplePermissions(),
                result -> {
                    boolean cameraGranted = checkSelfPermission(
                            Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED;
                    boolean micGranted = checkSelfPermission(
                            Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED;
                    boolean locationGranted = checkSelfPermission(
                            Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED ||
                            checkSelfPermission(
                                    Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED;

                    if (pendingWebPermissionRequest != null) {
                        PermissionRequest req = pendingWebPermissionRequest;
                        pendingWebPermissionRequest = null;
                        java.util.List<String> granted = new java.util.ArrayList<>();
                        for (String r : req.getResources()) {
                            if (PermissionRequest.RESOURCE_VIDEO_CAPTURE.equals(r) && cameraGranted) {
                                granted.add(r);
                            } else if (PermissionRequest.RESOURCE_AUDIO_CAPTURE.equals(r) && micGranted) {
                                granted.add(r);
                            }
                        }
                        if (!granted.isEmpty()) {
                            req.grant(granted.toArray(new String[0]));
                        } else {
                            req.deny();
                        }
                    }

                    if (pendingGeolocationCallback != null) {
                        android.webkit.GeolocationPermissions.Callback cb = pendingGeolocationCallback;
                        String origin = pendingGeolocationOrigin;
                        pendingGeolocationCallback = null;
                        pendingGeolocationOrigin = null;
                        cb.invoke(origin, locationGranted, true);
                    }
                });
        photoChooserLauncher = registerForActivityResult(
                new ActivityResultContracts.StartActivityForResult(),
                this::handlePhotoChooserResult);
        speechRecognitionLauncher = registerForActivityResult(
                new ActivityResultContracts.StartActivityForResult(),
                result -> {
                    if (voiceRequestCancelled || result.getResultCode() != RESULT_OK ||
                            result.getData() == null) {
                        sendVoiceMessage("stopped", "", "");
                        return;
                    }
                    java.util.ArrayList<String> matches = result.getData().getStringArrayListExtra(
                            RecognizerIntent.EXTRA_RESULTS);
                    String transcript = matches == null || matches.isEmpty() ? "" : matches.get(0);
                    if (transcript.trim().isEmpty()) {
                        sendVoiceMessage("error", "recognition", "");
                    } else {
                        sendVoiceMessage("result", "", transcript);
                    }
                });

        appRoot = new FrameLayout(this);
        appRoot.setBackgroundColor(Color.rgb(11, 16, 33));
        webView = new WebView(this);
        webView.setBackgroundColor(Color.rgb(11, 16, 33));
        webView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        appRoot.addView(webView, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT));
        loadingScreen = createLoadingScreen();
        appRoot.addView(loadingScreen, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT));
        setContentView(appRoot);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setDomStorageEnabled(true);
        webView.getSettings().setDatabaseEnabled(true);
        webView.getSettings().setCacheMode(WebSettings.LOAD_DEFAULT);
        webView.getSettings().setMediaPlaybackRequiresUserGesture(true);
        webView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        webView.getSettings().setSupportMultipleWindows(true);
        webView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        webView.getSettings().setGeolocationEnabled(true);
        webView.getSettings().setUserAgentString(
                webView.getSettings().getUserAgentString() + " DivineClassesAndroid/2.5");
        webView.addJavascriptInterface(new AndroidVoiceInputBridge(), "androidVoiceInput");
        webView.addJavascriptInterface(new AndroidSupabaseBridge(), "androidSupabase");
        webView.addJavascriptInterface(new AndroidExternalLinkBridge(), "android");
        webView.addJavascriptInterface(new AndroidExternalLinkBridge(), "androidBridge");
        CookieManager.getInstance().setAcceptThirdPartyCookies(webView, true);
        CookieManager.getInstance().setAcceptFileSchemeCookies(true);
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                if (request == null || request.getUrl() == null) {
                    return false;
                }
                // Never intercept sub-resources, iframes, or API calls (e.g. Supabase, CDNs)
                if (!request.isForMainFrame()) {
                    return false;
                }
                String url = request.getUrl().toString();
                if (!isAppUrl(url)) {
                    openExternalIntent(url);
                    return true;
                }
                return false;
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url == null || url.trim().isEmpty() || "about:blank".equalsIgnoreCase(url)) {
                    return false;
                }
                if (!isAppUrl(url)) {
                    openExternalIntent(url);
                    return true;
                }
                return false;
            }

            @Override
            public void onPageStarted(WebView view, String url, android.graphics.Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                if (url != null && isAppHost(Uri.parse(url).getHost())) {
                    portalLoadFailed = false;
                    portalLoadInProgress = true;
                    appReadySignaled = false;
                }
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                if (url != null && isAppHost(Uri.parse(url).getHost())) {
                    portalLoadInProgress = false;
                    if (portalLoadFailed) {
                        return;
                    }
                    pageLoaded = true;
                    internetAvailable = true;
                    hideAppsScriptNotice(view);
                    removeOfflineScreen();
                    String host = Uri.parse(url).getHost();
                    if (appReadySignaled || (host != null && host.contains("accounts.google.com"))) {
                        dismissLoadingScreen();
                    } else if (loadingScreen != null && loadingFallbackRunnable == null) {
                        loadingFallbackRunnable = () -> dismissLoadingScreen();
                        mainHandler.postDelayed(loadingFallbackRunnable, 4500);
                    }
                }
            }

            @Override
            public void onReceivedError(
                    WebView view,
                    WebResourceRequest request,
                    WebResourceError error) {
                super.onReceivedError(view, request, error);
                if (request != null && request.isForMainFrame()) {
                    showPortalLoadFailure();
                }
            }
        });
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onCreateWindow(
                    WebView view,
                    boolean isDialog,
                    boolean isUserGesture,
                    android.os.Message resultMsg) {
                // Invisible background WebView solely to capture the intended target URL.
                // It is NEVER added to the view hierarchy, so it never renders or crashes on
                // screen.
                final WebView tempWebView = new WebView(view.getContext());
                tempWebView.getSettings().setJavaScriptEnabled(true);
                tempWebView.setWebViewClient(new WebViewClient() {
                    private boolean handled = false;

                    private void routeUrl(String url) {
                        if (handled || url == null || url.trim().isEmpty() || "about:blank".equalsIgnoreCase(url)) {
                            return;
                        }
                        handled = true;
                        if (!isAppUrl(url)) {
                            openExternalIntent(url);
                        } else if (webView != null) {
                            webView.loadUrl(url);
                        }
                        mainHandler.post(() -> {
                            try {
                                tempWebView.stopLoading();
                                tempWebView.destroy();
                            } catch (Exception ignored) {
                            }
                        });
                    }

                    @Override
                    public boolean shouldOverrideUrlLoading(WebView v, WebResourceRequest request) {
                        String url = request.getUrl() != null ? request.getUrl().toString() : "";
                        routeUrl(url);
                        return true;
                    }

                    @Override
                    public boolean shouldOverrideUrlLoading(WebView v, String url) {
                        routeUrl(url);
                        return true;
                    }

                    @Override
                    public void onPageStarted(WebView v, String url, android.graphics.Bitmap favicon) {
                        super.onPageStarted(v, url, favicon);
                        if (url != null && !url.isEmpty() && !"about:blank".equalsIgnoreCase(url)) {
                            v.stopLoading();
                            routeUrl(url);
                        }
                    }

                    @Override
                    public void onReceivedError(WebView v, WebResourceRequest request, WebResourceError error) {
                        String url = request.getUrl() != null ? request.getUrl().toString() : "";
                        routeUrl(url);
                    }
                });

                WebView.WebViewTransport transport = (WebView.WebViewTransport) resultMsg.obj;
                transport.setWebView(tempWebView);
                resultMsg.sendToTarget();
                return true;
            }

            @Override
            public void onCloseWindow(WebView window) {
                super.onCloseWindow(window);
                try {
                    window.destroy();
                } catch (Exception ignored) {
                }
            }

            @Override
            public boolean onShowFileChooser(
                    WebView view,
                    ValueCallback<Uri[]> filePathCallback,
                    FileChooserParams fileChooserParams) {
                if (pendingFileChooser != null) {
                    pendingFileChooser.onReceiveValue(null);
                }
                pendingFileChooser = filePathCallback;
                pendingFileChooserParams = fileChooserParams;
                if (checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
                    pendingFileChooserParams = null;
                    launchPhotoChooser(fileChooserParams, true);
                } else {
                    cameraPermissionLauncher.launch(Manifest.permission.CAMERA);
                }
                return true;
            }

            @Override
            public void onPermissionRequest(PermissionRequest request) {
                runOnUiThread(() -> {
                    String[] resources = request.getResources();
                    java.util.List<String> granted = new java.util.ArrayList<>();
                    boolean needsCamera = false;
                    boolean needsMic = false;

                    for (String r : resources) {
                        if (PermissionRequest.RESOURCE_VIDEO_CAPTURE.equals(r)) {
                            if (checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
                                granted.add(r);
                            } else {
                                needsCamera = true;
                            }
                        } else if (PermissionRequest.RESOURCE_AUDIO_CAPTURE.equals(r)) {
                            if (checkSelfPermission(
                                    Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
                                granted.add(r);
                            } else {
                                needsMic = true;
                            }
                        } else {
                            granted.add(r);
                        }
                    }

                    if (needsCamera || needsMic) {
                        pendingWebPermissionRequest = request;
                        java.util.List<String> reqs = new java.util.ArrayList<>();
                        if (needsCamera)
                            reqs.add(Manifest.permission.CAMERA);
                        if (needsMic)
                            reqs.add(Manifest.permission.RECORD_AUDIO);
                        appPermissionsLauncher.launch(reqs.toArray(new String[0]));
                    } else if (!granted.isEmpty()) {
                        request.grant(granted.toArray(new String[0]));
                    } else {
                        request.deny();
                    }
                });
            }

            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                super.onProgressChanged(view, newProgress);
                if (loadingProgressBar != null) {
                    loadingProgressBar.setProgress(newProgress);
                }
                if (loadingProgressLabel != null) {
                    loadingProgressLabel.setText(newProgress + "%");
                }
            }

            @Override
            public void onGeolocationPermissionsShowPrompt(
                    String origin,
                    android.webkit.GeolocationPermissions.Callback callback) {
                if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                        ||
                        checkSelfPermission(
                                Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                    callback.invoke(origin, true, true);
                } else {
                    pendingGeolocationOrigin = origin;
                    pendingGeolocationCallback = callback;
                    appPermissionsLauncher.launch(new String[] {
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_COARSE_LOCATION
                    });
                }
            }
        });

        setupConnectivityMonitoring();
        internetAvailable = hasValidatedInternet();
        if (internetAvailable) {
            webView.loadUrl(APP_URL);
        } else {
            showOfflineScreen();
        }
    }

    private void launchPhotoChooser(FileChooserParams params, boolean cameraPermissionGranted) {
        Intent contentIntent;
        try {
            contentIntent = params.createIntent();
        } catch (ActivityNotFoundException | IllegalArgumentException error) {
            contentIntent = new Intent(Intent.ACTION_GET_CONTENT);
            contentIntent.setType("image/*");
            contentIntent.addCategory(Intent.CATEGORY_OPENABLE);
        }

        String[] acceptTypes = params.getAcceptTypes();
        boolean acceptsImages = acceptTypes == null || acceptTypes.length == 0;
        if (acceptTypes != null) {
            for (String acceptType : acceptTypes) {
                if (acceptType != null &&
                        (acceptType.startsWith("image/") || acceptType.equals("*/*"))) {
                    acceptsImages = true;
                    break;
                }
            }
        }

        Intent chooser = Intent.createChooser(contentIntent, "Choose student photo");
        if (acceptsImages && cameraPermissionGranted) {
            Intent cameraIntent = createCameraCaptureIntent();
            if (cameraIntent != null && params.isCaptureEnabled()) {
                chooser = cameraIntent;
            } else if (cameraIntent != null) {
                chooser.putExtra(Intent.EXTRA_INITIAL_INTENTS, new Intent[] { cameraIntent });
            }
        }

        try {
            photoChooserLauncher.launch(chooser);
        } catch (ActivityNotFoundException error) {
            completeFileChooser(null);
        }
    }

    private Intent createCameraCaptureIntent() {
        Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (cameraIntent.resolveActivity(getPackageManager()) == null) {
            return null;
        }

        ContentValues values = new ContentValues();
        values.put(MediaStore.Images.Media.DISPLAY_NAME,
                "divine-student-" + System.currentTimeMillis() + ".jpg");
        values.put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            values.put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/Divine Classes");
            values.put(MediaStore.Images.Media.IS_PENDING, 1);
        }
        pendingCameraPhotoUri = getContentResolver().insert(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                values);
        if (pendingCameraPhotoUri == null) {
            return null;
        }

        cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, pendingCameraPhotoUri);
        cameraIntent.setClipData(android.content.ClipData.newRawUri(
                "Student photo",
                pendingCameraPhotoUri));
        cameraIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION |
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        return cameraIntent;
    }

    private void handlePhotoChooserResult(ActivityResult result) {
        Uri[] selectedUris = null;
        if (result.getResultCode() == RESULT_OK) {
            Intent data = result.getData();
            if (data != null && data.getClipData() != null) {
                android.content.ClipData clipData = data.getClipData();
                selectedUris = new Uri[clipData.getItemCount()];
                for (int i = 0; i < clipData.getItemCount(); i++) {
                    selectedUris[i] = clipData.getItemAt(i).getUri();
                }
            } else if (data != null && data.getData() != null) {
                selectedUris = new Uri[] { data.getData() };
            } else if (pendingCameraPhotoUri != null) {
                selectedUris = new Uri[] { pendingCameraPhotoUri };
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    ContentValues values = new ContentValues();
                    values.put(MediaStore.Images.Media.IS_PENDING, 0);
                    getContentResolver().update(pendingCameraPhotoUri, values, null, null);
                }
            }
        }

        if (selectedUris == null && pendingCameraPhotoUri != null) {
            getContentResolver().delete(pendingCameraPhotoUri, null, null);
        }
        pendingCameraPhotoUri = null;
        completeFileChooser(selectedUris);
    }

    private void completeFileChooser(Uri[] selectedUris) {
        if (pendingFileChooser != null) {
            pendingFileChooser.onReceiveValue(selectedUris);
            pendingFileChooser = null;
        }
    }

    private void setupConnectivityMonitoring() {
        connectivityManager = (ConnectivityManager) getSystemService(CONNECTIVITY_SERVICE);
        if (connectivityManager == null) {
            return;
        }
        networkCallback = new ConnectivityManager.NetworkCallback() {
            @Override
            public void onAvailable(Network network) {
                updateConnectionState(hasValidatedInternet());
            }

            @Override
            public void onCapabilitiesChanged(Network network, NetworkCapabilities capabilities) {
                boolean validated = capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
                        capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED);
                updateConnectionState(validated);
            }

            @Override
            public void onLost(Network network) {
                updateConnectionState(hasValidatedInternet());
            }
        };
        connectivityManager.registerDefaultNetworkCallback(networkCallback);
        networkCallbackRegistered = true;
    }

    private boolean hasValidatedInternet() {
        if (connectivityManager == null) {
            connectivityManager = (ConnectivityManager) getSystemService(CONNECTIVITY_SERVICE);
        }
        if (connectivityManager == null) {
            return false;
        }
        Network activeNetwork = connectivityManager.getActiveNetwork();
        if (activeNetwork == null) {
            return false;
        }
        NetworkCapabilities capabilities = connectivityManager.getNetworkCapabilities(activeNetwork);
        return capabilities != null &&
                capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
                capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED);
    }

    private void updateConnectionState(boolean connected) {
        mainHandler.post(() -> {
            if (isFinishing() || isDestroyed()) {
                return;
            }
            boolean stateChanged = internetAvailable != connected;
            internetAvailable = connected;
            if (connected) {
                if (offlineScreen != null && !portalLoadInProgress) {
                    retryPortalLoad();
                }
            } else if (!pageLoaded && (stateChanged || offlineScreen == null)) {
                portalLoadInProgress = false;
                showOfflineScreen();
            }
        });
    }

    private void showPortalLoadFailure() {
        runOnUiThread(() -> {
            portalLoadFailed = true;
            portalLoadInProgress = false;
            internetAvailable = hasValidatedInternet();
            if (loadingScreen != null) {
                loadingScreen.setVisibility(View.GONE);
            }
            showOfflineScreen();
        });
    }

    private void retryPortalLoad() {
        if (webView == null || portalLoadInProgress || !hasValidatedInternet()) {
            return;
        }
        internetAvailable = true;
        portalLoadFailed = false;
        portalLoadInProgress = true;
        removeOfflineScreen();
        if (loadingScreen == null) {
            loadingScreen = createLoadingScreen();
            appRoot.addView(loadingScreen, new FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT));
        } else {
            loadingScreen.setVisibility(View.VISIBLE);
            loadingScreen.setAlpha(1f);
        }
        if (pageLoaded) {
            webView.reload();
        } else {
            webView.loadUrl(APP_URL);
        }
    }

    private void showOfflineScreen() {
        if (appRoot == null || offlineScreen != null) {
            return;
        }
        if (loadingScreen != null) {
            loadingScreen.setVisibility(View.GONE);
        }

        LinearLayout content = new LinearLayout(this);
        content.setBackgroundColor(Color.WHITE);
        content.setGravity(Gravity.CENTER);
        content.setOrientation(LinearLayout.VERTICAL);
        int sidePadding = dp(32);
        content.setPadding(sidePadding, dp(36), sidePadding, dp(36));

        ImageView logo = new ImageView(this);
        logo.setImageResource(R.drawable.logo);
        logo.setScaleType(ImageView.ScaleType.FIT_CENTER);
        content.addView(logo, new LinearLayout.LayoutParams(dp(112), dp(112)));

        TextView title = new TextView(this);
        title.setText("No internet connection");
        title.setTextColor(Color.rgb(15, 23, 42));
        title.setTextSize(21);
        title.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        title.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams titleParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        titleParams.topMargin = dp(24);
        content.addView(title, titleParams);

        TextView message = new TextView(this);
        message.setText(
                "We can’t reach Divine Classes right now. Check your internet connection and we’ll reconnect automatically.");
        message.setTextColor(Color.rgb(100, 116, 139));
        message.setTextSize(15);
        message.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams messageParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        messageParams.topMargin = dp(10);
        content.addView(message, messageParams);

        TextView retry = new TextView(this);
        retry.setText("Try again");
        retry.setTextColor(Color.WHITE);
        retry.setTextSize(15);
        retry.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        retry.setGravity(Gravity.CENTER);
        GradientDrawable retryBackground = new GradientDrawable();
        retryBackground.setColor(BLUE);
        retryBackground.setCornerRadius(dp(12));
        retry.setBackground(retryBackground);
        retry.setOnClickListener(view -> {
            if (hasValidatedInternet()) {
                retryPortalLoad();
            }
        });
        LinearLayout.LayoutParams retryParams = new LinearLayout.LayoutParams(dp(160), dp(48));
        retryParams.topMargin = dp(24);
        content.addView(retry, retryParams);

        offlineScreen = content;
        appRoot.addView(offlineScreen, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT));
    }

    private void removeOfflineScreen() {
        if (appRoot != null && offlineScreen != null) {
            appRoot.removeView(offlineScreen);
            offlineScreen = null;
        }
        if (loadingScreen != null) {
            loadingScreen.setVisibility(View.VISIBLE);
        }
    }

    private void handleWebPermissionRequest(PermissionRequest request) {
        String[] resources = request.getResources();
        boolean isCamera = resources != null && resources.length == 1 &&
                PermissionRequest.RESOURCE_VIDEO_CAPTURE.equals(resources[0]);
        if (request.getOrigin() == null || !isAppHost(request.getOrigin().getHost()) || !isCamera) {
            request.deny();
            return;
        }

        if (checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
            request.grant(new String[] { PermissionRequest.RESOURCE_VIDEO_CAPTURE });
            return;
        }
        pendingCameraRequest = request;
        cameraPermissionLauncher.launch(Manifest.permission.CAMERA);
    }

    private View createLoadingScreen() {
        FrameLayout screen = new FrameLayout(this);
        screen.setBackgroundColor(Color.rgb(16, 24, 39));

        LinearLayout content = new LinearLayout(this);
        content.setGravity(Gravity.CENTER);
        content.setOrientation(LinearLayout.VERTICAL);
        int sidePadding = dp(32);
        content.setPadding(sidePadding, dp(36), sidePadding, dp(36));

        ImageView logo = new ImageView(this);
        logo.setImageResource(R.drawable.logo);
        logo.setScaleType(ImageView.ScaleType.FIT_CENTER);
        LinearLayout.LayoutParams logoParams = new LinearLayout.LayoutParams(dp(132), dp(132));
        content.addView(logo, logoParams);

        loadingProgressBar = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        loadingProgressBar.setMax(100);
        loadingProgressBar.setProgress(0);
        loadingProgressBar.setProgressTintList(android.content.res.ColorStateList.valueOf(Color.WHITE));
        loadingProgressBar.setProgressBackgroundTintList(
                android.content.res.ColorStateList.valueOf(0x66FFFFFF));
        LinearLayout.LayoutParams progressBarParams = new LinearLayout.LayoutParams(
                dp(132),
                dp(8));
        progressBarParams.topMargin = dp(18);
        content.addView(loadingProgressBar, progressBarParams);

        FrameLayout.LayoutParams contentParams = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.WRAP_CONTENT,
                Gravity.CENTER);
        screen.addView(content, contentParams);
        return screen;
    }

    private void dismissLoadingScreen() {
        if (loadingFallbackRunnable != null) {
            mainHandler.removeCallbacks(loadingFallbackRunnable);
            loadingFallbackRunnable = null;
        }
        if (loadingScreen != null) {
            final View screen = loadingScreen;
            loadingScreen = null;
            loadingProgressBar = null;
            loadingProgressLabel = null;
            screen.animate()
                    .alpha(0f)
                    .setDuration(220)
                    .withEndAction(() -> {
                        if (appRoot != null) {
                            appRoot.removeView(screen);
                        }
                    })
                    .start();
        }
    }

    private int dp(int value) {
        return Math.round(value * getResources().getDisplayMetrics().density);
    }

    private void hideAppsScriptNotice(WebView view) {
        String script = "(function() {" +
                "var notice = /this application was created by a google apps script user/i;" +
                "function removeNotice() {" +
                "var nodes = document.querySelectorAll('body *');" +
                "for (var i = 0; i < nodes.length; i++) {" +
                "var node = nodes[i];" +
                "if (node.children.length === 0 && notice.test((node.textContent || '').trim())) {" +
                "var container = node;" +
                "for (var depth = 0; depth < 5 && container.parentElement && container.parentElement !== document.body; depth++) {"
                +
                "var parent = container.parentElement;" +
                "var parentText = (parent.textContent || '').trim();" +
                "if (parentText.length > 180) break;" +
                "container = parent;" +
                "}" +
                "container.style.setProperty('display', 'none', 'important');" +
                "}" +
                "}" +
                "}" +
                "removeNotice();" +
                "new MutationObserver(removeNotice).observe(document.documentElement, {childList:true,subtree:true});" +
                "function isExt(u) {" +
                "if (!u || typeof u !== 'string') return false;" +
                "if (u.indexOf('#') === 0 || u.indexOf('javascript:') === 0) return false;" +
                "try {" +
                "var p = document.createElement('a');" +
                "p.href = u;" +
                "var h = (p.hostname || '').toLowerCase();" +
                "return h && h !== 'script.google.com' && !h.endsWith('.script.googleusercontent.com') && h !== 'accounts.google.com';"
                +
                "} catch(e) { return false; }" +
                "}" +
                "var origOpen = window.open;" +
                "window.open = function(u) {" +
                "if (u && isExt(u) && window.android && window.android.openExternal) {" +
                "window.android.openExternal(u);" +
                "return null;" +
                "}" +
                "return origOpen ? origOpen.apply(this, arguments) : null;" +
                "};" +
                "document.addEventListener('click', function(e) {" +
                "var a = e.target.closest ? e.target.closest('a') : null;" +
                "if (a && a.href && isExt(a.href)) {" +
                "if (window.android && window.android.openExternal) {" +
                "e.preventDefault();" +
                "e.stopPropagation();" +
                "window.android.openExternal(a.href);" +
                "}" +
                "}" +
                "}, true);" +
                "})();";
        view.evaluateJavascript(script, null);
    }

    private boolean isAppHost(String host) {
        if (host == null) {
            return false;
        }
        return APP_HOSTS.contains(host) ||
                host.equals("google.com") ||
                host.endsWith(".google.com") ||
                host.equals("googleusercontent.com") ||
                host.endsWith(".googleusercontent.com") ||
                host.endsWith(".gstatic.com") ||
                host.equals("supabase.co") ||
                host.endsWith(".supabase.co") ||
                host.equals("cloudflare.com") ||
                host.endsWith(".cloudflare.com") ||
                host.equals("tailwindcss.com") ||
                host.endsWith(".tailwindcss.com") ||
                host.endsWith(".fontawesome.com");
    }

    private boolean isAppUrl(String url) {
        if (url == null || url.trim().isEmpty() || "about:blank".equalsIgnoreCase(url)) {
            return true;
        }
        Uri uri = Uri.parse(url);
        String scheme = uri.getScheme();
        if (scheme == null) {
            return false;
        }
        if (!"https".equalsIgnoreCase(scheme) && !"http".equalsIgnoreCase(scheme)) {
            return false;
        }
        String host = uri.getHost();
        if (host == null) {
            return false;
        }
        return isAppHost(host);
    }

    private boolean openExternalIntent(String url) {
        if (url == null) {
            return false;
        }
        url = url.trim();
        if (url.isEmpty() || "about:blank".equalsIgnoreCase(url)) {
            return false;
        }
        if (!url.startsWith("http://") && !url.startsWith("https://") && !url.startsWith("intent:")) {
            url = "https://" + url;
        }
        try {
            Intent intent;
            if (url.startsWith("intent:")) {
                intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
            } else {
                intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            return true;
        } catch (Exception e) {
            try {
                if (url.startsWith("intent:")) {
                    Intent parsed = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
                    String fallbackUrl = parsed.getStringExtra("browser_fallback_url");
                    if (fallbackUrl != null) {
                        Intent fallbackIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(fallbackUrl.trim()));
                        fallbackIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(fallbackIntent);
                        return true;
                    }
                }
            } catch (Exception ignored) {
            }
            try {
                Intent fallback = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                fallback.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(fallback);
                return true;
            } catch (Exception ignored) {
            }
            return false;
        }
    }

    public final class AndroidExternalLinkBridge {
        @JavascriptInterface
        public void openExternal(String url) {
            if (url != null) {
                runOnUiThread(() -> openExternalIntent(url));
            }
        }

        @JavascriptInterface
        public void openUrl(String url) {
            if (url != null) {
                runOnUiThread(() -> openExternalIntent(url));
            }
        }
    }

    public final class AndroidVoiceInputBridge {
        @JavascriptInterface
        public void startListening() {
            runOnUiThread(() -> {
                String currentUrl = webView == null ? null : webView.getUrl();
                Uri currentUri = currentUrl == null ? null : Uri.parse(currentUrl);
                if (currentUri == null || !"https".equals(currentUri.getScheme()) ||
                        !isAppHost(currentUri.getHost())) {
                    sendVoiceMessage("error", "unavailable", "");
                    return;
                }
                voiceRequestCancelled = false;
                if (checkSelfPermission(Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
                    startNativeSpeechRecognition();
                } else {
                    microphonePermissionLauncher.launch(Manifest.permission.RECORD_AUDIO);
                }
            });
        }

        @JavascriptInterface
        public void stopListening() {
            runOnUiThread(() -> {
                voiceRequestCancelled = true;
                sendVoiceMessage("stopped", "", "");
            });
        }
    }

    private void startNativeSpeechRecognition() {
        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        if (intent.resolveActivity(getPackageManager()) == null) {
            sendVoiceMessage("error", "unavailable", "");
            return;
        }
        try {
            intent.putExtra(
                    RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                    RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
            intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Speak your message");
            intent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, false);
            sendVoiceMessage("listening", "", "");
            speechRecognitionLauncher.launch(intent);
        } catch (ActivityNotFoundException | SecurityException error) {
            sendVoiceMessage("error", "unavailable", "");
        }
    }

    private void sendVoiceMessage(String type, String code, String transcript) {
        String currentUrl = webView == null ? null : webView.getUrl();
        Uri currentUri = currentUrl == null ? null : Uri.parse(currentUrl);
        if (currentUri != null && isAppHost(currentUri.getHost())) {
            String message = createVoiceMessage(type, code, transcript);
            webView.evaluateJavascript(
                    "window.dispatchEvent(new CustomEvent('divine-android-voice',{detail:" +
                            message + "}));",
                    null);
        }
    }

    private String createVoiceMessage(String type, String code, String transcript) {
        JSONObject message = new JSONObject();
        try {
            message.put("type", type);
            message.put("code", code);
            message.put("transcript", transcript);
        } catch (org.json.JSONException error) {
            throw new IllegalStateException("Could not encode voice input response.", error);
        }
        return message.toString();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        if (webView != null) {
            webView.saveState(outState);
        }
        super.onSaveInstanceState(outState);
    }

    @Override
    public void onBackPressed() {
        if (webView != null && webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (connectivityManager != null) {
            boolean connected = hasValidatedInternet();
            if (connected && offlineScreen != null) {
                retryPortalLoad();
            } else {
                updateConnectionState(connected);
            }
        }
    }

    @Override
    protected void onDestroy() {
        voiceRequestCancelled = true;
        mainHandler.removeCallbacksAndMessages(null);
        if (networkCallbackRegistered && connectivityManager != null && networkCallback != null) {
            connectivityManager.unregisterNetworkCallback(networkCallback);
            networkCallbackRegistered = false;
        }
        if (pendingCameraRequest != null) {
            pendingCameraRequest.deny();
            pendingCameraRequest = null;
        }
        completeFileChooser(null);
        if (pendingCameraPhotoUri != null) {
            getContentResolver().delete(pendingCameraPhotoUri, null, null);
            pendingCameraPhotoUri = null;
        }
        if (webView != null) {
            webView.destroy();
            webView = null;
        }
        super.onDestroy();
    }

    /**
     * JavaScript bridge for Android WebView to directly sync with Supabase.
     * Called from the web app when google.script.run is unavailable.
     * Sends state data to the Apps Script doPost endpoint via Android's
     * HttpURLConnection.
     */
    @SuppressWarnings("unused")
    public final class AndroidSupabaseBridge {
        @JavascriptInterface
        public void syncStateToCloud(String jsonState) {
            try {
                final String stateJson = jsonState;
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            java.net.URL url = new java.net.URL(APP_URL);
                            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
                            conn.setRequestMethod("POST");
                            conn.setRequestProperty("Content-Type", "application/json");
                            conn.setRequestProperty("Accept", "application/json");
                            conn.setDoOutput(true);
                            conn.setConnectTimeout(15000);
                            conn.setReadTimeout(15000);

                            String body = "{\"action\":\"sync_state\",\"data\":" + stateJson + "}";
                            byte[] postBytes = body.getBytes(java.nio.charset.StandardCharsets.UTF_8);
                            conn.setFixedLengthStreamingMode(postBytes.length);

                            java.io.OutputStream os = conn.getOutputStream();
                            os.write(postBytes);
                            os.flush();
                            os.close();

                            int responseCode = conn.getResponseCode();
                            java.io.InputStream is;
                            if (responseCode >= 200 && responseCode < 300) {
                                is = conn.getInputStream();
                            } else {
                                is = conn.getErrorStream();
                            }
                            if (is != null) {
                                java.io.BufferedReader reader = new java.io.BufferedReader(
                                        new java.io.InputStreamReader(is, java.nio.charset.StandardCharsets.UTF_8));
                                StringBuilder sb = new StringBuilder();
                                String line;
                                while ((line = reader.readLine()) != null) {
                                    sb.append(line);
                                }
                                reader.close();
                            }
                            is.close();
                            conn.disconnect();

                            mainHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    if (webView != null) {
                                        webView.evaluateJavascript(
                                                "if(typeof window.__androidSyncComplete === 'function') window.__androidSyncComplete("
                                                        + responseCode + ");",
                                                null);
                                    }
                                }
                            });
                        } catch (Exception e) {
                            e.printStackTrace();
                            mainHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    if (webView != null) {
                                        webView.evaluateJavascript(
                                                "if(typeof window.__androidSyncComplete === 'function') window.__androidSyncComplete(0);",
                                                null);
                                    }
                                }
                            });
                        }
                    }
                }).start();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @JavascriptInterface
        public String getWebAppUrl() {
            return APP_URL;
        }

        @JavascriptInterface
        public void onAppReady() {
            appReadySignaled = true;
            mainHandler.post(() -> dismissLoadingScreen());
        }
    }
}
