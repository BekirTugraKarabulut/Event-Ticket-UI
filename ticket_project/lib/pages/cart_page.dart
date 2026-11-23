
import 'package:flutter/material.dart';
import 'package:ticket_project/pages/pay_page.dart';
import 'package:ticket_project/services/CartService.dart';

class CartPage extends StatefulWidget {
  final String username;

  const CartPage({
    super.key,
    required this.username,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService cartService = CartService();

  late Future<List<dynamic>> cartFuture;
  late Future<int> totalFuture;

  int? updatingCartId;
  int? deletingCartId;

  @override
  void initState() {
    super.initState();

    cartFuture = cartService.getCartList(widget.username);
    totalFuture = cartService.getSumPay(widget.username);
  }

  String getImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return "";
    }

    if (imageUrl.startsWith("http")) {
      return imageUrl;
    }

    return "http://10.0.2.2:8082$imageUrl";
  }

  void refreshCart() {
    setState(() {
      cartFuture = cartService.getCartList(widget.username);
      totalFuture = cartService.getSumPay(widget.username);
    });
  }

  Future<void> changeQuantity(
      int sepetId,
      int currentQuantity,
      int change,
      ) async {
    final int newQuantity = currentQuantity + change;

    if (newQuantity < 1) return;

    setState(() {
      updatingCartId = sepetId;
    });

    try {
      await cartService.updateCart(sepetId, newQuantity);

      if (!mounted) return;

      setState(() {
        cartFuture = cartService.getCartList(widget.username);
        totalFuture = cartService.getSumPay(widget.username);
        updatingCartId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bilet adedi güncellendi."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        updatingCartId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Güncelleme başarısız: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteCartItem(int sepetId) async {
    final bool? onay = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sepeti Sil"),
          content: const Text(
            "Bu etkinliği sepetinizden silmek istediğinize emin misiniz?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Vazgeç"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Sil"),
            ),
          ],
        );
      },
    );

    if (onay != true) return;

    setState(() {
      deletingCartId = sepetId;
    });

    try {
      await cartService.deleteCart(sepetId);

      if (!mounted) return;

      setState(() {
        cartFuture = cartService.getCartList(widget.username);
        totalFuture = cartService.getSumPay(widget.username);
        deletingCartId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Etkinlik sepetten silindi."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        deletingCartId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Silme işlemi başarısız: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildQuantityControl(Map<String, dynamic> cart) {
    final int? sepetId = int.tryParse(
      cart["sepetId"]?.toString() ?? "",
    );

    final int quantity = int.tryParse(
      cart["quantity"]?.toString() ?? "",
    ) ?? 1;

    if (sepetId == null) {
      return const Text(
        "Sepet ID bilgisi bulunamadı.",
        style: TextStyle(
          color: Colors.red,
          fontSize: 13,
        ),
      );
    }

    final bool isUpdating = updatingCartId == sepetId;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.confirmation_number_outlined,
            color: Colors.green,
            size: 21,
          ),

          const SizedBox(width: 8),

          const Text(
            "Bilet adedi",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const Spacer(),

          if (isUpdating)
            const SizedBox(
              width: 110,
              height: 36,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.green,
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                IconButton(
                  onPressed: quantity <= 1
                      ? null
                      : () => changeQuantity(
                    sepetId,
                    quantity,
                    -1,
                  ),
                  icon: const Icon(Icons.remove),
                  color: Colors.green,
                  disabledColor: Colors.grey.shade300,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                    minimumSize: const Size(36, 36),
                    maximumSize: const Size(36, 36),
                  ),
                ),

                SizedBox(
                  width: 35,
                  child: Text(
                    "$quantity",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () => changeQuantity(
                    sepetId,
                    quantity,
                    1,
                  ),
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(36, 36),
                    maximumSize: const Size(36, 36),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildDeleteButton(Map<String, dynamic> cart) {
    final int? sepetId = int.tryParse(
      cart["sepetId"]?.toString() ?? "",
    );

    if (sepetId == null) {
      return const SizedBox.shrink();
    }

    final bool isDeleting = deletingCartId == sepetId;

    return IconButton(
      onPressed: isDeleting
          ? null
          : () => deleteCartItem(sepetId),
      icon: isDeleting
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.red,
        ),
      )
          : const Icon(
        Icons.delete_outline,
        color: Colors.red,
        size: 26,
      ),
      tooltip: "Sepetten sil",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sepetim",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: refreshCart,
            icon: const Icon(Icons.refresh),
            tooltip: "Sepeti yenile",
          ),
        ],
      ),

      body: FutureBuilder<List<dynamic>>(
        future: cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 55,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "Sepet yüklenemedi:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      onPressed: refreshCart,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Tekrar dene"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final carts = snapshot.data ?? [];

          if (carts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Sepetiniz henüz boş.",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Beğendiğiniz etkinlikleri sepete ekleyebilirsiniz.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: carts.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> cart =
              Map<String, dynamic>.from(carts[index]);

              final String imageUrl =
              getImageUrl(cart["imageUrl"]?.toString());

              final double price = double.tryParse(
                cart["price"]?.toString() ?? "0",
              ) ?? 0;

              final int quantity = int.tryParse(
                cart["quantity"]?.toString() ?? "1",
              ) ?? 1;

              final double totalPrice = price * quantity;

              final int? sepetId = int.tryParse(
                cart["sepetId"]?.toString() ?? "",
              );

              final bool isDeleting = deletingCartId == sepetId;

              return Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: imageUrl.isEmpty
                          ? Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      )
                          : Image.network(
                        imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  cart["name"]?.toString() ?? "",
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              buildDeleteButton(cart),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.green,
                                size: 18,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                "${cart["day"] ?? ""} - ${cart["date"] ?? ""}",
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.green,
                                size: 18,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                cart["time"]?.toString() ?? "",
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 18,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  cart["place"]?.toString() ?? "",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Bilet fiyatı",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${price.toStringAsFixed(2)} TL",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Ürün toplamı",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${totalPrice.toStringAsFixed(2)} TL",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          if (isDeleting)
                            const LinearProgressIndicator(
                              color: Colors.red,
                            )
                          else
                            buildQuantityControl(cart),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: FutureBuilder<List<dynamic>>(
        future: cartFuture,
        builder: (context, cartSnapshot) {
          if (!cartSnapshot.hasData || cartSnapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          return FutureBuilder<int>(
            future: totalFuture,
            builder: (context, totalSnapshot) {
              final bool isLoading =
                  totalSnapshot.connectionState == ConnectionState.waiting;

              final int total = totalSnapshot.data ?? 0;

              return SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Toplam Tutar",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 5),

                            if (isLoading)
                              const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.green,
                                ),
                              )
                            else if (totalSnapshot.hasError)
                              const Text(
                                "Hesaplanamadı",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else
                              Text(
                                "$total TL",
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: isLoading || totalSnapshot.hasError
                                ? null
                                : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PayPage(username: widget.username),
                                ),
                              );
                            },
                            icon: const Icon(Icons.payment),
                            label: const Text(
                              "Ödeme Yap",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
