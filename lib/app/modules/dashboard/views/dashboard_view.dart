import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx/app/data/EntertainmentResponse.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../../../data/HeadlineResponse.dart';
import '../../../data/SportsResponse.dart';
import '../../../data/TechnologyResponse.dart';
import '../../home/views/home_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());
    final ScrollController scrollController = ScrollController();
    final auth = GetStorage();
    // Mendefinisikan sebuah widget bernama build dengan tipe StatelessWidget yang memerlukan BuildContext.
    return SafeArea(
      // Widget SafeArea menempatkan semua konten widget ke dalam area yang aman (safe area) dari layar.
      child: DefaultTabController(
        length: 5,
        // Widget DefaultTabController digunakan untuk mengatur tab di aplikasi.
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await auth.erase();
              Get.offAll(() => HomeView());
            },
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.logout_rounded),
          ),
          // Widget Scaffold digunakan sebagai struktur dasar aplikasi.
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120.0),
            // Widget PreferredSize digunakan untuk menyesuaikan tinggi appBar.
            child: Column(
              // Widget Column adalah widget yang menyatukan widget-childnya secara vertikal.
              children: [
                ListTile(
                  // Widget ListTile digunakan untuk menampilkan tampilan list sederhana.
                  title: const Text(
                    "Hallo!",
                    textAlign: TextAlign.end,
                    // Properti textAlign digunakan untuk menentukan perataan teks.
                  ),
                  subtitle: Text(
                    auth.read('full_name').toString(),
                    textAlign: TextAlign.end,
                  ),
                  trailing: Container(
                    // Widget Container digunakan untuk mengatur tampilan konten dalam kotak.
                    margin: const EdgeInsets.only(right: 10),
                    // Properti margin digunakan untuk menentukan jarak dari tepi kontainer ke tepi widget yang di dalamnya.
                    width: 50.0,
                    height: 50.0,
                    child: Lottie.network(
                      // Widget Lottie.network digunakan untuk menampilkan animasi Lottie dari suatu URL.
                      'https://gist.githubusercontent.com/olipiskandar/2095343e6b34255dcfb042166c4a3283/raw/d76e1121a2124640481edcf6e7712130304d6236/praujikom_kucing.json',
                      fit: BoxFit.cover,
                      // Properti fit digunakan untuk menyesuaikan ukuran konten agar sesuai dengan kontainer.
                    ),
                  ),
                ),
                const Align(
                  // Widget Align digunakan untuk menempatkan widget pada posisi tertentu di dalam widget induk.
                  alignment: Alignment.topLeft,
                  // Properti alignment digunakan untuk menentukan letak widget di dalam widget induk.
                  child: TabBar(
                    // Widget TabBar digunakan untuk menampilkan tab di aplikasi.
                    labelColor: Colors.black,
                    // Properti labelColor digunakan untuk menentukan warna teks tab yang dipilih.
                    indicatorSize: TabBarIndicatorSize.label,
                    // Properti indicatorSize digunakan untuk menentukan ukuran indikator tab yang dipilih.
                    isScrollable: true,
                    // Properti isScrollable digunakan untuk menentukan apakah tab dapat di-scroll atau tidak.
                    indicatorColor: Colors.white,
                    // Properti indicatorColor digunakan untuk menentukan warna indikator tab yang dipilih.
                    tabs: [
                      // Properti tabs digunakan untuk menentukan teks yang akan ditampilkan pada masing-masing tab.
                      Tab(text: "Headline"),
                      Tab(text: "Teknologi"),
                      Tab(text: "Olahraga"),
                      Tab(text: "Hiburan"),
                      Tab(text: "Profile"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            // Widget TabBarView digunakan untuk menampilkan konten yang terkait dengan masing-masing tab.
            children: [
              // Properti children digunakan untuk menentukan konten yang akan ditampilkan pada masing-masing tab.
              entertainment(controller, scrollController),
              headline(controller, scrollController),
              sports(controller, scrollController),
              technology(controller, scrollController),
              profile(controller, scrollController),
            ],
          ),
        ),
      ),
    );
  }
  // Function untuk menampilkan daftar headline berita dalam bentuk ListView.Builder dengan menggunakan data yang didapatkan dari future yang dikembalikan oleh controller
  FutureBuilder<EntertainmentResponse> entertainment(
      DashboardController controller, ScrollController scrollController) {
    return FutureBuilder<EntertainmentResponse>(
      // Mendapatkan future data headline dari controller
      future: controller.getEntertainment(),
      builder: (context, snapshot) {
        // Jika koneksi masih dalam keadaan waiting/tunggu, tampilkan widget Lottie loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              // Menggunakan animasi Lottie untuk tampilan loading
              'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
              repeat: true,
              width: MediaQuery.of(context).size.width / 1,
            ),
          );
        }
        // Jika tidak ada data yang diterima, tampilkan pesan "Tidak ada data"
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        // Jika data diterima, tampilkan daftar headline dalam bentuk ListView.Builder
        return ListView.builder(
          itemCount: snapshot.data!.data!.length,
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // Tampilan untuk setiap item headline dalam ListView.Builder
            return Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 8,
                right: 8,
                bottom: 5,
              ),
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widget untuk menampilkan gambar headline dengan menggunakan url gambar dari data yang diterima
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      snapshot.data!.data![index].urlToImage.toString(),
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Widget untuk menampilkan judul headline dengan menggunakan data yang diterima
                        Text(
                          snapshot.data!.data![index].title.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        // Widget untuk menampilkan informasi author dan sumber headline dengan menggunakan data yang diterima
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Author : ${snapshot.data!.data![index].author}'),
                            Text('Sumber :${snapshot.data!.data![index].name}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  FutureBuilder<HeadlineResponse> headline(
      DashboardController controller, ScrollController scrollController) {
    return FutureBuilder<HeadlineResponse>(
      // Mendapatkan future data headline dari controller
      future: controller.getHeadline(),
      builder: (context, snapshot) {
        // Jika koneksi masih dalam keadaan waiting/tunggu, tampilkan widget Lottie loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              // Menggunakan animasi Lottie untuk tampilan loading
              'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
              repeat: true,
              width: MediaQuery.of(context).size.width / 1,
            ),
          );
        }
        // Jika tidak ada data yang diterima, tampilkan pesan "Tidak ada data"
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        // Jika data diterima, tampilkan daftar headline dalam bentuk ListView.Builder
        return ListView.builder(
          itemCount: snapshot.data!.data!.length,
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // Tampilan untuk setiap item headline dalam ListView.Builder
            return Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 8,
                right: 8,
                bottom: 5,
              ),
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widget untuk menampilkan gambar headline dengan menggunakan url gambar dari data yang diterima
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      snapshot.data!.data![index].urlToImage.toString(),
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Widget untuk menampilkan judul headline dengan menggunakan data yang diterima
                        Text(
                          snapshot.data!.data![index].title.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        // Widget untuk menampilkan informasi author dan sumber headline dengan menggunakan data yang diterima
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Author : ${snapshot.data!.data![index].author}'),
                            Text('Sumber :${snapshot.data!.data![index].name}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  FutureBuilder<SportsResponse> sports(
      DashboardController controller, ScrollController scrollController) {
    return FutureBuilder<SportsResponse>(
      // Mendapatkan future data headline dari controller
      future: controller.getSports(),
      builder: (context, snapshot) {
        // Jika koneksi masih dalam keadaan waiting/tunggu, tampilkan widget Lottie loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              // Menggunakan animasi Lottie untuk tampilan loading
              'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
              repeat: true,
              width: MediaQuery.of(context).size.width / 1,
            ),
          );
        }
        // Jika tidak ada data yang diterima, tampilkan pesan "Tidak ada data"
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        // Jika data diterima, tampilkan daftar headline dalam bentuk ListView.Builder
        return ListView.builder(
          itemCount: snapshot.data!.data!.length,
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // Tampilan untuk setiap item headline dalam ListView.Builder
            return Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 8,
                right: 8,
                bottom: 5,
              ),
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widget untuk menampilkan gambar headline dengan menggunakan url gambar dari data yang diterima
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      snapshot.data!.data![index].urlToImage.toString(),
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Widget untuk menampilkan judul headline dengan menggunakan data yang diterima
                        Text(
                          snapshot.data!.data![index].title.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        // Widget untuk menampilkan informasi author dan sumber headline dengan menggunakan data yang diterima
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Author : ${snapshot.data!.data![index].author}'),
                            Text('Sumber :${snapshot.data!.data![index].name}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  FutureBuilder<TechnologyResponse> technology(
      DashboardController controller, ScrollController scrollController) {
    return FutureBuilder<TechnologyResponse>(
      // Mendapatkan future data headline dari controller
      future: controller.getTechnology(),
      builder: (context, snapshot) {
        // Jika koneksi masih dalam keadaan waiting/tunggu, tampilkan widget Lottie loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              // Menggunakan animasi Lottie untuk tampilan loading
              'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
              repeat: true,
              width: MediaQuery.of(context).size.width / 1,
            ),
          );
        }
        // Jika tidak ada data yang diterima, tampilkan pesan "Tidak ada data"
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        // Jika data diterima, tampilkan daftar headline dalam bentuk ListView.Builder
        return ListView.builder(
          itemCount: snapshot.data!.data!.length,
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // Tampilan untuk setiap item headline dalam ListView.Builder
            return Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 8,
                right: 8,
                bottom: 5,
              ),
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widget untuk menampilkan gambar headline dengan menggunakan url gambar dari data yang diterima
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      snapshot.data!.data![index].urlToImage.toString(),
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Widget untuk menampilkan judul headline dengan menggunakan data yang diterima
                        Text(
                          snapshot.data!.data![index].title.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        // Widget untuk menampilkan informasi author dan sumber headline dengan menggunakan data yang diterima
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Author : ${snapshot.data!.data![index].author}'),
                            Text('Sumber :${snapshot.data!.data![index].name}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
SingleChildScrollView profile(DashboardController controller, ScrollController scrollController) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                    "data:image/png;base64,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",
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Akbar 3 Andika',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '@akbar33',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network('https://cdn-icons-png.flaticon.com/512/2111/2111425.png', height: 35),
              Image.network('https://cdn-icons-png.flaticon.com/512/3059/3059997.png', height: 35),
              Image.network('https://cdn-icons-png.flaticon.com/512/733/733579.png', height: 35),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Hello, introduce my name is Akbar 3 Andika. I am a student at SMK Assalaam Bandung who is currently learning web programming. For now I already have fundamental knowledge about several programming languages and several frameworks likes PHP, HTML, CSS, Javascript, Bootstrap, Laravel, Flutter, etc.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

