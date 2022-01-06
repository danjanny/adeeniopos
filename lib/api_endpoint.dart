class ApiEndpoint {
  // PAK LURAH BANDI
  // static const domain = 'http://192.168.8.116/';
  // static const plainDomain = '192.168.8.116';

  // DANJANNY
  // static const domain = 'http://192.168.0.7/';
  // static const plainDomain = '192.168.0.7';

  // SERUI
  // static const domain = 'http://192.168.1.10/';
  // static const plainDomain = '192.168.1.10';

  // PRODUCTION
  static const domain = 'https://izulfikar.com/';
  static const plainDomain = 'izulfikar.com';

  // static const baseUrl = domain + 'backend80/public/auths/';
  // static const checkUserEmail = baseUrl + "check-user-email";

  // base url
  static const baseUrl = domain + 'backend80/public/pos/';

  // auth login
  static const authUrl = baseUrl + 'login';

  // product
  // static const productUrl = baseUrl + 'product';
  static const productUrl = 'backend80/public/pos/product';
  static const addProductUrl =
      domain + 'backend80/public/pos/product/add-product';

  // submit order http post
  static const orderUrl = domain + 'backend80/public/pos/order/add';

  // index product url
  static const productIndexUrl = domain + 'backend80/public/pos/product';
  static const productIndexUrlNew = 'backend80/public/pos/product';
  static const productListUrl = "backend80/public/pos/product/list-product";

  // order history url
  static const orderHistoryUrl = 'backend80/public/pos/order-history';

  // update status pembayaran post url
  static const updatePaymentStatusUrl =
      domain + 'backend80/public/pos/update-payment-status';

  // report
  static const reportUrl = 'backend80/public/pos/report';

  // report - order history
  static const reportOrderHistoryUrl =
      'backend80/public/pos/report/order-history';


}
