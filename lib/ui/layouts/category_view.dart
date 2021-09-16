import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  //temporary list
  final List<ScrapCategoryModel> scrapList = [
    ScrapCategoryModel(
        1, 'Đồng đỏ', 'https://phelieusatthep.com/upload/daj1432025718.jpg', [
      ScrapCategoryDetailModel.withPrice(1, "kg", 100000, 0),
      ScrapCategoryDetailModel.withPrice(2, "g", 100, 0),
      ScrapCategoryDetailModel.withPrice(3, "cái", 200000, 0),
    ]),
    ScrapCategoryModel(
        2,
        'Sắt vụn',
        'https://m.baotuyenquang.com.vn/media/images/2021/06/img_20210619224824.png',
        [
          ScrapCategoryDetailModel.withPrice(1, "kg", 100000, 0),
          ScrapCategoryDetailModel.withPrice(2, "g", 100, 0),
          ScrapCategoryDetailModel.withPrice(3, "cái", 200000, 0),
        ]),
    ScrapCategoryModel(
        3,
        'Chai nhựa',
        'https://phelieuviet.com/wp-content/uploads/2020/05/thu-mua-vo-chai-nhua.png',
        [
          ScrapCategoryDetailModel.withPrice(1, "kg", 100000, 0),
          ScrapCategoryDetailModel.withPrice(2, "g", 100, 0),
          ScrapCategoryDetailModel.withPrice(3, "cái", 200000, 0),
        ]),
    ScrapCategoryModel(
        4,
        'Nhôm loại 3',
        'https://thumuaphelieutuankiet.com/upload/sanpham/gia-nhom-phe-lieu-hom-nay-cao-nhat-2020-5405.jpg',
        [
          ScrapCategoryDetailModel.withPrice(1, "kg", 100000, 0),
          ScrapCategoryDetailModel.withPrice(2, "g", 100, 0),
          ScrapCategoryDetailModel.withPrice(3, "cái", 200000, 0),
        ]),
    ScrapCategoryModel(5, 'Inox 304',
        'https://phelieuvietduc.com/wp-content/uploads/2019/12/inox-304.jpg', [
      ScrapCategoryDetailModel.withPrice(1, "kg", 100000, 0),
      ScrapCategoryDetailModel.withPrice(2, "g", 100, 0),
      ScrapCategoryDetailModel.withPrice(3, "cái", 200000, 0),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    //sort list
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
                backgroundImage: NetworkImage(model.getImageUrl),
              ),
            ),
          ),
          title: Text(model.getName),
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
