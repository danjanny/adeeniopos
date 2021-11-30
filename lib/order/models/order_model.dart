class Order {
  late int id;
  late int productId;
  late String itemNm;
  late int itemPrice;
  late int itemPcs;
  late String itemNote;
  late int itemSubtotal;

  Order(this.productId, this.itemNm, this.itemPrice, this.itemPcs,
      this.itemNote, this.itemSubtotal);

  Order.fetch(this.id, this.productId, this.itemNm, this.itemPrice, this.itemPcs,
      this.itemNote, this.itemSubtotal);

  Map<String, Object> toMap() {
    var map = <String, Object>{
      'product_id': productId,
      'item_nm': itemNm,
      'item_price': itemPrice,
      'item_pcs': itemPcs,
      'item_note': itemNote,
      'item_subtotal': itemSubtotal
    };
    return map;
  }

  @override
  String toString() {
    return "Data order : $productId, $itemNm, $itemPrice, $itemPcs, $itemNote, $itemSubtotal";
  }
}
