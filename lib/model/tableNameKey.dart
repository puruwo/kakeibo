class TBL001RecordKey {
  final String _tableName = 'Payment';

  final String _id = '_id';
  final String _year = 'year';
  final String _month = 'month';
  final String _day = 'day';
  final String _price = 'price';
  final String _paymentCategoryId = 'payment_category_id';
  final String _memo = 'memo';
  
  String get tableName => _tableName;
  String get id => _id;
  String get year => _year;
  String get month => _month;
  String get day => _day;
  String get price => _price;
  String get paymentCategoryId => _paymentCategoryId;
  String get memo => _memo;
}

class TBL002RecordKey {
  final String _tableName = 'Income';

  final String _id = '_id';
  final String _year = 'year';
  final String _month = 'month';
  final String _day = 'day';
  final String _price = 'price';
  final String _incomeCategoryId = 'income_category_id';
  final String _memo = 'memo';

  String get tableName => _tableName;
  String get id => _id;
  String get year => _year;
  String get month => _month;
  String get day => _day;
  String get price => _price;
  String get incomeCategoryId => _incomeCategoryId;
  String get memo => _memo;
}

class TBL003RecordKey {
  final String _tableName = 'Category';

  final String _id = '_id';
  final String _smallCategoryKey = 'small_category_key';
  final String _bigCategoryKey = 'big_category_key';
  final String _categoryName = 'category_name';
  final String _defaultDisplayed = 'default_displayed';

  String get tableName => _tableName;
  String get id => _id;
  String get smallCategoryKey => _smallCategoryKey;
  String get bigCategoryKey => _bigCategoryKey;
  String get categoryName => _categoryName;
  String get defaultDisplayed => _defaultDisplayed;
}

class TBL004RecordKey {
  final String _tableName = 'BigCategoryInfo';

  final String _id = '_id';
  final String _colorCode = 'color_code';
  final String _bigCategoryName = 'big_category_name';
  final String _resourcePath = 'resource_path';
  final String _displayOrder = 'display_order';
  final String _isDisplayed = 'is_displayed';

  String get tableName => _tableName;
  String get id => _id;
  String get colorCode => _colorCode;
  String get bigCategoryName => _bigCategoryName;
  String get resourcePath => _resourcePath;
  String get displayOrder => _displayOrder;
  String get isDisplayed => _isDisplayed;
}

class SeparateLabelMapKey {
  final String _id = '_id';
  final String _year = 'year';
  final String _month = 'month';
  final String _day = 'day';
  final String _price = 'price';
  final String _category = 'payment_category_id';
  final String _memo = 'memo';
  final String _dateTime = 'dateTime';

  String get id => _id;
  String get year => _year;
  String get month => _month;
  String get day => _day;
  String get price => _price;
  String get category => _category;
  String get memo => _memo;
  String get dateTime => _dateTime;
}

