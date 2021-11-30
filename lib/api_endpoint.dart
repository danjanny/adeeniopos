class ApiEndpoint {

  // PAK LURAH BANDI
  // static const domain = 'http://192.168.8.116/';
  // static const plainDomain = '192.168.8.116';

  // DANJANNY
  // static const domain = 'http://192.168.43.197/';
  // static const plainDomain = '192.168.43.197';

  // SERUI
  static const domain = 'http://192.168.1.6/';
  static const plainDomain = '192.168.1.6';

  // static const baseUrl = domain + 'backend80/public/auths/';
  // static const checkUserEmail = baseUrl + "check-user-email";

  // base url
  static const baseUrl = domain + 'backend80/public/pos/';

  // auth login
  static const authUrl = baseUrl + 'login';

  // product
  // static const productUrl = baseUrl + 'product';
  static const productUrl = 'backend80/public/pos/product';

  // submit order http post
  static const orderUrl = domain + 'backend80/public/pos/order/add';

}
