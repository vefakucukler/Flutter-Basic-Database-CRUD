import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FirebaseCrud(),
  ));
}

class FirebaseCrud extends StatefulWidget {
  @override
  _FirebaseCrudState createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
  //---------------------------------------

  String ad, id, kategori;
  int sayfaSayisi;

  idAl(idTutucu) {
    this.id = idTutucu;
  }

  adAl(adTutucu) {
    this.ad = adTutucu;
  }

  kategoriAl(kategoriTutucu) {
    this.kategori = kategoriTutucu;
  }

  sayfaAl(sayfaTutucu) {
    this.sayfaSayisi = int.parse(sayfaTutucu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Crud"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (String idTutucu) {
                idAl(idTutucu);
              },
              decoration: InputDecoration(
                labelText: "Kitap ID",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (String adTutucu) {
                adAl(adTutucu);
              },
              decoration: InputDecoration(
                labelText: "Kitap Adı",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (String kategoriTutucu) {
                kategoriAl(kategoriTutucu);
              },
              decoration: InputDecoration(
                labelText: "Kitap Kategorisi",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (String sayfaTutucu) {
                sayfaAl(sayfaTutucu);
              },
              decoration: InputDecoration(
                labelText: "Kitap Sayfası",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    veriEkle();
                  },
                  child: Text("Ekle"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shadowColor: Colors.redAccent,
                    elevation: 5,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    veriOku();
                  },
                  child: Text("Oku"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    onPrimary: Colors.white,
                    shadowColor: Colors.redAccent,
                    elevation: 5,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    veriGuncelle();
                  },
                  child: Text("Güncelle"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    shadowColor: Colors.redAccent,
                    elevation: 5,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    veriSil();
                  },
                  child: Text("Sil"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shadowColor: Colors.redAccent,
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("Kitaplik").snapshots(),
            builder: (context, alinanVeri) {
              if (alinanVeri.hasError) {
                return Text("Aktarım Başarız");
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: alinanVeri.data.docs.length,
                itemBuilder: (contex, index) {
                  DocumentSnapshot satirVerisi = alinanVeri.data.docs[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(50, 15, 25, 0),
                    child: Row(
                      children: [
                        Expanded(child: Text(satirVerisi["kitapAdi"])),
                        Expanded(child: Text(satirVerisi["kitapKategorisi"])),
                        Expanded(child: Text(satirVerisi["kitapSayisi"].toString())),
                        Expanded(child: Text(satirVerisi["kitapId"])),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  //-------------------------------------METOTLAR---------------------
// Firebaseye Veri Ekler

  void veriEkle() {
    DocumentReference veriyolu =
        FirebaseFirestore.instance.collection("Kitaplik").doc(id);

    Map<String, dynamic> kitaplar = {
      "kitapId": id,
      "kitapAdi": ad,
      "kitapKategorisi": kategori,
      "kitapSayisi": sayfaSayisi.toString(),
    };
    veriyolu.set(kitaplar).whenComplete(() => {
          Fluttertoast.showToast(msg: id + "ID'li kitap eklendi"),
        });
  }

//Firebaseden Veri Okur

  void veriOku() {
    DocumentReference veriOkumaYolu =
        FirebaseFirestore.instance.collection("Kitaplik").doc(id);
    veriOkumaYolu.get().then((alinanDeger) {
      Map<String, dynamic> alinanVeri = alinanDeger.data();

      String idTutucu = alinanVeri["kitapId"];
      String adTutucu = alinanVeri["kitapAdi"];
      String kategoriTutucu = alinanVeri["kitapKategorisi"];
      String sayfaTutucu = alinanVeri["kitapSayisi"];

      Fluttertoast.showToast(
          msg: "Id: " +
              idTutucu +
              " Ad: " +
              adTutucu +
              " Kategori: " +
              kategoriTutucu +
              " Sayfa Sayısı: " +
              sayfaTutucu);
    });
  }

// Firebasede Veri Günceller
  void veriGuncelle() {
    DocumentReference veriGuncellemeYolu =
        FirebaseFirestore.instance.collection("Kitaplik").doc(id);

    Map<String, dynamic> guncellenecekVeri = {
      "kitapId": id,
      "kitapAdi": ad,
      "kitapKategorisi": kategori,
      "kitapSayisi": sayfaSayisi.toString(),
    };

    veriGuncellemeYolu.update(guncellenecekVeri).whenComplete(() {
      Fluttertoast.showToast(msg: id + "'li Kitap Güncellendi");
    });
  }

// Firebaseden Veri Siler
  void veriSil() {
    DocumentReference veriSilmeYolu =
        FirebaseFirestore.instance.collection("Kitaplik").doc(id);

    veriSilmeYolu.delete().whenComplete(() {
      Fluttertoast.showToast(msg: id + " 'li kitap silindi.");
    });
  }
}
