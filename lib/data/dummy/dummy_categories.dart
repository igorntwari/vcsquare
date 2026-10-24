// Placeholder marketplace categories for building screens before real data.
import 'package:flutter/material.dart';

import '../models/category_model.dart';

const List<CategoryModel> dummyCategories = [
  CategoryModel(id: 'electronics', name: 'Electronics', icon: Icons.laptop),
  CategoryModel(id: 'furniture', name: 'Furniture', icon: Icons.chair_outlined),
  CategoryModel(
    id: 'appliances',
    name: 'Appliances',
    icon: Icons.microwave_outlined,
  ),
  CategoryModel(
    id: 'books',
    name: 'Books & Notes',
    icon: Icons.menu_book_outlined,
  ),
  CategoryModel(
    id: 'clothing',
    name: 'Clothing',
    icon: Icons.checkroom_outlined,
  ),
  CategoryModel(id: 'housing', name: 'Housing', icon: Icons.home_work_outlined),
  CategoryModel(
    id: 'services',
    name: 'Services',
    icon: Icons.handyman_outlined,
  ),
  CategoryModel(id: 'other', name: 'Other', icon: Icons.grid_view),
];
