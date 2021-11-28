class Order {
  late int id;
  late int productId;
  late String itemName;
  late int itemPrice;
  late int itemPcs;
  late String itemNote;
  late int itemSubtotal;

  Order(this.productId, this.itemName, this.itemPrice, this.itemPcs,
      this.itemNote, this.itemSubtotal);

  Order.fetch(this.id, this.productId, this.itemName, this.itemPrice, this.itemPcs,
      this.itemNote, this.itemSubtotal);

  Map<String, Object> toMap() {
    var map = <String, Object>{
      'product_id': productId,
      'item_nm': itemName,
      'item_price': itemPrice,
      'item_pcs': itemPcs,
      'item_note': itemNote,
      'item_subtotal': itemSubtotal
    };
    return map;
  }

  @override
  String toString() {
    return "Data order : $productId, $itemName, $itemPrice, $itemPcs, $itemNote, $itemSubtotal";
  }
}
