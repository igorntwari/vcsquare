// Placeholder marketplace categories for building screens before real data.
import '../models/category_model.dart';

const List<CategoryModel> dummyCategories = [
  CategoryModel(id: 'electronics', name: 'Electronics', iconName: 'laptop', order: 0),
  CategoryModel(id: 'furniture', name: 'Furniture', iconName: 'chair_outlined', order: 1),
  CategoryModel(
    id: 'appliances',
    name: 'Appliances',
    iconName: 'microwave_outlined',
    order: 2,
  ),
  CategoryModel(
    id: 'books',
    name: 'Books & Notes',
    iconName: 'menu_book_outlined',
    order: 3,
  ),
  CategoryModel(
    id: 'clothing',
    name: 'Clothing',
    iconName: 'checkroom_outlined',
    order: 4,
  ),
  CategoryModel(id: 'housing', name: 'Housing', iconName: 'home_work_outlined', order: 5),
  CategoryModel(
    id: 'services',
    name: 'Services',
    iconName: 'handyman_outlined',
    order: 6,
  ),
  CategoryModel(id: 'other', name: 'Other', iconName: 'grid_view', order: 7),
];
