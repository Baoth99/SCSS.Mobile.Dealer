import 'package:dealer_app/repositories/models/scrap_category.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //temporary list
    final List<ScrapCategoryModel> scrapList = [
      ScrapCategoryModel(
          1, 'Đồng đỏ', 'https://phelieusatthep.com/upload/daj1432025718.jpg'),
      ScrapCategoryModel(2, 'Sắt vụn',
          'https://m.baotuyenquang.com.vn/media/images/2021/06/img_20210619224824.png'),
      ScrapCategoryModel(3, 'Chai nhựa',
          'https://phelieuviet.com/wp-content/uploads/2020/05/thu-mua-vo-chai-nhua.png'),
      ScrapCategoryModel(4, 'Nhôm loại 3',
          'https://thumuaphelieutuankiet.com/upload/sanpham/gia-nhom-phe-lieu-hom-nay-cao-nhat-2020-5405.jpg'),
      ScrapCategoryModel(5, 'Inox 304',
          'https://phelieuvietduc.com/wp-content/uploads/2019/12/inox-304.jpg'),
    ];
    scrapList.sort();
    // category screen
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ScreenTitles.categoryScreenTitle,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.of(context).pushNamed("/addCategory"),
            child: Container(
              width: 60,
              child: Center(
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: scrapList.length,
            itemBuilder: (_, index) {
              return _listTileBuilder(scrapList[index]);
            },
          )),
    );
  }

  _listTileBuilder(ScrapCategoryModel model) {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            height: 40,
            width: 40,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 65,
              child: CircleAvatar(
                radius: 65,
                backgroundImage: NetworkImage(model.imageUrl),
              ),
            ),
          ),
          title: Text(model.name),
        ),
        Divider(
          color: Colors.grey.shade200,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}
