// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_attribute_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProductAttributeCollection on Isar {
  IsarCollection<ProductAttribute> get productAttributes => this.collection();
}

const ProductAttributeSchema = CollectionSchema(
  name: r'ProductAttribute',
  id: -5234703614320360831,
  properties: {
    r'basicDataCategoryName': PropertySchema(
      id: 0,
      name: r'basicDataCategoryName',
      type: IsarType.string,
    ),
    r'isProductVariant': PropertySchema(
      id: 1,
      name: r'isProductVariant',
      type: IsarType.bool,
    ),
    r'values': PropertySchema(
      id: 2,
      name: r'values',
      type: IsarType.stringList,
    )
  },
  estimateSize: _productAttributeEstimateSize,
  serialize: _productAttributeSerialize,
  deserialize: _productAttributeDeserialize,
  deserializeProp: _productAttributeDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _productAttributeGetId,
  getLinks: _productAttributeGetLinks,
  attach: _productAttributeAttach,
  version: '3.1.0+1',
);

int _productAttributeEstimateSize(
  ProductAttribute object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.basicDataCategoryName.length * 3;
  bytesCount += 3 + object.values.length * 3;
  {
    for (var i = 0; i < object.values.length; i++) {
      final value = object.values[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _productAttributeSerialize(
  ProductAttribute object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.basicDataCategoryName);
  writer.writeBool(offsets[1], object.isProductVariant);
  writer.writeStringList(offsets[2], object.values);
}

ProductAttribute _productAttributeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProductAttribute(
    basicDataCategoryName: reader.readString(offsets[0]),
    isProductVariant: reader.readBool(offsets[1]),
    values: reader.readStringList(offsets[2]) ?? [],
  );
  object.isarId = id;
  return object;
}

P _productAttributeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _productAttributeGetId(ProductAttribute object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _productAttributeGetLinks(ProductAttribute object) {
  return [];
}

void _productAttributeAttach(
    IsarCollection<dynamic> col, Id id, ProductAttribute object) {
  object.isarId = id;
}

extension ProductAttributeQueryWhereSort
    on QueryBuilder<ProductAttribute, ProductAttribute, QWhere> {
  QueryBuilder<ProductAttribute, ProductAttribute, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProductAttributeQueryWhere
    on QueryBuilder<ProductAttribute, ProductAttribute, QWhereClause> {
  QueryBuilder<ProductAttribute, ProductAttribute, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProductAttributeQueryFilter
    on QueryBuilder<ProductAttribute, ProductAttribute, QFilterCondition> {
  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'basicDataCategoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'basicDataCategoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'basicDataCategoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'basicDataCategoryName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'basicDataCategoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'basicDataCategoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'basicDataCategoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'basicDataCategoryName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'basicDataCategoryName',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      basicDataCategoryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'basicDataCategoryName',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      isProductVariantEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isProductVariant',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'values',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'values',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'values',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'values',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterFilterCondition>
      valuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ProductAttributeQueryObject
    on QueryBuilder<ProductAttribute, ProductAttribute, QFilterCondition> {}

extension ProductAttributeQueryLinks
    on QueryBuilder<ProductAttribute, ProductAttribute, QFilterCondition> {}

extension ProductAttributeQuerySortBy
    on QueryBuilder<ProductAttribute, ProductAttribute, QSortBy> {
  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      sortByBasicDataCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'basicDataCategoryName', Sort.asc);
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      sortByBasicDataCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'basicDataCategoryName', Sort.desc);
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      sortByIsProductVariant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProductVariant', Sort.asc);
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      sortByIsProductVariantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProductVariant', Sort.desc);
    });
  }
}

extension ProductAttributeQuerySortThenBy
    on QueryBuilder<ProductAttribute, ProductAttribute, QSortThenBy> {
  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      thenByBasicDataCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'basicDataCategoryName', Sort.asc);
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      thenByBasicDataCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'basicDataCategoryName', Sort.desc);
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      thenByIsProductVariant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProductVariant', Sort.asc);
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      thenByIsProductVariantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProductVariant', Sort.desc);
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension ProductAttributeQueryWhereDistinct
    on QueryBuilder<ProductAttribute, ProductAttribute, QDistinct> {
  QueryBuilder<ProductAttribute, ProductAttribute, QDistinct>
      distinctByBasicDataCategoryName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'basicDataCategoryName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QDistinct>
      distinctByIsProductVariant() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isProductVariant');
    });
  }

  QueryBuilder<ProductAttribute, ProductAttribute, QDistinct>
      distinctByValues() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'values');
    });
  }
}

extension ProductAttributeQueryProperty
    on QueryBuilder<ProductAttribute, ProductAttribute, QQueryProperty> {
  QueryBuilder<ProductAttribute, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ProductAttribute, String, QQueryOperations>
      basicDataCategoryNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'basicDataCategoryName');
    });
  }

  QueryBuilder<ProductAttribute, bool, QQueryOperations>
      isProductVariantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isProductVariant');
    });
  }

  QueryBuilder<ProductAttribute, List<String>, QQueryOperations>
      valuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'values');
    });
  }
}
