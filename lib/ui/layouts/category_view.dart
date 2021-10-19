import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  //temporary list
  final List<ScrapCategoryModelTemp> scrapList = [
    ScrapCategoryModelTemp(
        id: 1,
        name: 'Đồng đỏ',
        imageUrl: 'https://phelieusatthep.com/upload/daj1432025718.jpg',
        accountId: 0,
        createdBy: 0,
        createdTime: DateTime(2021, 9, 2),
        status: 0,
        updatedBy: 0,
        updatedTime: DateTime(2021, 10, 2),
        unitList: [
          ScrapCategoryDetailModelTemp(
            id: 1,
            scrapCategoryId: 1,
            unit: "kg",
            price: 100000,
            createdBy: 0,
            createdTime: DateTime(2021, 9, 2),
            status: 0,
            updatedBy: 0,
            updatedTime: DateTime(2021, 10, 2),
          ),
          ScrapCategoryDetailModelTemp(
            id: 2,
            scrapCategoryId: 1,
            unit: "g",
            price: 100,
            createdBy: 0,
            createdTime: DateTime(2021, 9, 2),
            status: 0,
            updatedBy: 0,
            updatedTime: DateTime(2021, 10, 2),
          ),
          ScrapCategoryDetailModelTemp(
            id: 3,
            scrapCategoryId: 1,
            unit: "cái",
            price: 20000,
            createdBy: 0,
            createdTime: DateTime(2021, 9, 2),
            status: 0,
            updatedBy: 0,
            updatedTime: DateTime(2021, 10, 2),
          ),
        ]),
    ScrapCategoryModelTemp(
        id: 2,
        name: 'Sắt vụn',
        imageUrl:
            'https://m.baotuyenquang.com.vn/media/images/2021/06/img_20210619224824.png',
        accountId: 0,
        createdBy: 0,
        createdTime: DateTime(2021, 9, 2),
        status: 0,
        updatedBy: 0,
        updatedTime: DateTime(2021, 10, 2),
        unitList: [
          ScrapCategoryDetailModelTemp(
            id: 1,
            scrapCategoryId: 2,
            unit: "kg",
            price: 100000,
            createdBy: 0,
            createdTime: DateTime(2021, 9, 2),
            status: 0,
            updatedBy: 0,
            updatedTime: DateTime(2021, 10, 2),
          ),
          ScrapCategoryDetailModelTemp(
            id: 2,
            scrapCategoryId: 2,
            unit: "g",
            price: 100,
            createdBy: 0,
            createdTime: DateTime(2021, 9, 2),
            status: 0,
            updatedBy: 0,
            updatedTime: DateTime(2021, 10, 2),
          ),
          ScrapCategoryDetailModelTemp(
            id: 3,
            scrapCategoryId: 2,
            unit: "cái",
            price: 20000,
            createdBy: 0,
            createdTime: DateTime(2021, 9, 2),
            status: 0,
            updatedBy: 0,
            updatedTime: DateTime(2021, 10, 2),
          ),
        ]),
    ScrapCategoryModelTemp(
        id: 3,
        name: 'Chai nhựa',
        imageUrl:
            'https://phelieuviet.com/wp-content/uploads/2020/05/thu-mua-vo-chai-nhua.png',
        accountId: 0,
        createdBy: 0,
        createdTime: DateTime(2021, 9, 2),
        status: 0,
        updatedBy: 0,
        updatedTime: DateTime(2021, 10, 2),
        unitList: [
          ScrapCategoryDetailModelTemp(
            id: 1,
            scrapCategoryId: 3,
            unit: "kg",
            price: 100000,
            createdBy: 0,
            createdTime: DateTime(2021, 9, 2),
            status: 0,
            updatedBy: 0,
            updatedTime: DateTime(2021, 10, 2),
          ),
          ScrapCategoryDetailModelTemp(
            id: 2,
            scrapCategoryId: 3,
            unit: "g",
            price: 100,
            createdBy: 0,
            createdTime: DateTime(2021, 9, 2),
            status: 0,
            updatedBy: 0,
            updatedTime: DateTime(2021, 10, 2),
          ),
          ScrapCategoryDetailModelTemp(
            id: 3,
            scrapCategoryId: 3,
            unit: "cái",
            price: 20000,
            createdBy: 0,
            createdTime: DateTime(2021, 9, 2),
            status: 0,
            updatedBy: 0,
            updatedTime: DateTime(2021, 10, 2),
          ),
        ]),
    ScrapCategoryModelTemp(
      id: 4,
      name: 'Nhôm loại 3 không có unit',
      imageUrl:
          'https://thumuaphelieutuankiet.com/upload/sanpham/gia-nhom-phe-lieu-hom-nay-cao-nhat-2020-5405.jpg',
      accountId: 0,
      createdBy: 0,
      createdTime: DateTime(2021, 9, 2),
      status: 0,
      updatedBy: 0,
      updatedTime: DateTime(2021, 10, 2),
    ),
    ScrapCategoryModelTemp(
      id: 5,
      name:
          'Inox 304 k hình ảnh nhưng tên dài dàiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii rất dàiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii',
      accountId: 0,
      createdBy: 0,
      createdTime: DateTime(2021, 9, 2),
      status: 0,
      updatedBy: 0,
      updatedTime: DateTime(2021, 10, 2),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //sort list
    scrapList.sort();
    // category screen
    return Scaffold(
      appBar: AppBar(
        title: Text(
          CustomTexts.categoryScreenTitle,
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
            itemBuilder: (context, index) {
              return _listTileBuilder(scrapList[index], context);
            },
          )),
    );
  }

  _listTileBuilder(ScrapCategoryModelTemp model, context) {
    return Column(
      children: [
        ListTile(
          onTap: () => Navigator.of(context).pushNamed(
            '/categoryDetail',
            arguments: model,
          ),
          leading: SizedBox(
            height: 40,
            width: 40,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 65,
              child: CircleAvatar(
                radius: 65,
                backgroundImage: model.getImageUrl != null
                    ? NetworkImage(model.getImageUrl)
                    : null,
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
