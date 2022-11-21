import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:news_flutter/models/category.dart';
import 'package:news_flutter/viewmodel/article_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Category> categories = [
    Category('business', 'İş'),
    Category('entertaintment', 'Eğlence'),
    Category('general', 'Genel'),
    Category('health', 'Sağlık'),
    Category('science', 'Bilim'),
    Category('sports', 'Spor'),
    Category('technology', 'Teknoloji'),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ArticleListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title:const Text('Haberler'),
        ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height:60,
            width:double.infinity,
            child:ListView(
              scrollDirection: Axis.horizontal,
              children: getCategoriesTab(vm),
            ),
          ),
          getWidgetByStatus(vm)
        ],
      ),
    );
  }

  List<GestureDetector> getCategoriesTab (ArticleListViewModel vm){
    List<GestureDetector> list = [];
    for(int i=0; i<categories.length; i++){
      list.add(
        GestureDetector(
          onTap:() => vm.getNews(categories[i].key),
          child: Card(
            child:Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              categories[i].title, 
              style:const TextStyle(fontSize: 16), 
              ),
          )),
          )
      );
    }
    return list;
  }
  Widget getWidgetByStatus(ArticleListViewModel vm){
    switch(vm.status.index){
      case 2:
        return Expanded(child: ListView.builder(
        itemCount: vm.viewModel.articles.length,
        itemBuilder: (context, index){
        return Card(
          child: Column(
            children:[
              Image.network(vm.viewModel.articles[index].urlToImage??'https://media.istockphoto.com/vectors/default-image-icon-vector-missing-picture-page-for-website-design-or-vector-id1357365823?k=20&m=1357365823&s=612x612&w=0&h=ZH0MQpeUoSHM3G2AWzc8KkGYRg4uP_kuu0Za8GFxdFc='),
              ListTile(
                title: Text(
                  vm.viewModel.articles[index].title??'',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ) ,
                subtitle: 
                  Text(vm.viewModel.articles[index].description??'') ,
              ),
              ButtonBar(
                children: [
                  MaterialButton(
                    onPressed: () async{
                     await launchUrl(Uri.parse(vm.viewModel.articles[index].url??''));

                    },
                    child: const Text("Habere Git", style:TextStyle(color: Colors.blue),),
                     
                  ),
                ],
              )
            ]
          ),
        );
      
      }) ,);
      default:
        return const Center(child: CircularProgressIndicator(),);

    }
  }
}
