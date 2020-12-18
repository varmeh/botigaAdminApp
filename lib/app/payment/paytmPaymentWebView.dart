import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../util/index.dart' show AppTheme, Http;
import '../../widgets/index.dart' show LoaderOverlay;
import '../../models/index.dart' show SellerModel;

class PaytmPaymentWebView extends StatefulWidget {
  static const route = 'payment';

  final String paymentId;
  final String paymentToken;
  final SellerModel seller;

  PaytmPaymentWebView({
    @required this.paymentId,
    @required this.paymentToken,
    @required this.seller,
  });

  @override
  _PaytmPaymentWebViewState createState() => _PaytmPaymentWebViewState();
}

class _PaytmPaymentWebViewState extends State<PaytmPaymentWebView> {
  WebViewController _webController;
  bool _isLoading = true;
  bool _isWebViewVisible = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: LoaderOverlay(
          isLoading: _isLoading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Visibility(
              visible: _isWebViewVisible,
              child: WebView(
                debuggingEnabled: false,
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (url) {
                  print(url);
                  if (url.contains('/transaction/status')) {
                    _showPaymentStatus();
                  }
                },
                onPageFinished: (url) {
                  if (url.contains('showPaymentPage')) {
                    setState(() => _isLoading = false);
                  }
                },
                onWebViewCreated: (controller) {
                  _webController = controller;

                  _webController.loadUrl(new Uri.dataFromString(
                    _showPaymentPage(),
                    mimeType: 'text/html',
                  ).toString());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // https://developer.paytm.com/docs/show-payment-page/?ref=payments
  String _showPaymentPage() {
    final mid = 'BOTIGA19474156290102';
    return '''
		<html>
			<head>
				<title>Show Payment Page</title>
			</head>
			<body>
				<center>
					<h1 ${Platform.isAndroid ? '' : 'style="font-size:500%"'}>Please do not refresh this page...</h1>
				</center>
				<form method="post" action="https://securegw.paytm.in/theia/api/v1/showPaymentPage?mid=$mid&orderId=${widget.paymentId}" name="paytm">
					<table border="1">
							<tbody>
								<input type="hidden" name="mid" value="$mid">
								<input type="hidden" name="orderId" value="${widget.paymentId}">
								<input type="hidden" name="txnToken" value="${widget.paymentToken}">
							</tbody>
					</table>
					<script type="text/javascript"> document.paytm.submit(); </script>
				</form>
			</body>
		</html>
		''';
  }

  void _showPaymentStatus() async {
    setState(() {
      _isWebViewVisible = false;
      _isLoading = true;
    });
    try {
      final status = await Http.get(
          '/api/admin/transaction/status?paymentId=${widget.paymentId}');
      print(status);
      // Future.delayed(Duration(milliseconds: 25), () {
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     PageRouteBuilder(
      //       pageBuilder: (_, __, ___) => OrderStatusScreen(order),
      //       transitionDuration: Duration.zero,
      //     ),
      //     (route) => false,
      //   );
      // });
    } catch (_) {} finally {
      // Clear order list to enable reloading of orders
      setState(() => _isLoading = true);
    }
  }
}
