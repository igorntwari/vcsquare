# lib/ architecture rules

1. Feature-first structure with a shared layer.
2. A widget used by 2 or more features goes in `shared/widgets`. A widget used by only one feature stays in that feature's `widgets/` folder.
3. No hardcoded colors, text styles, spacing, radii or asset paths in screens. They come from `core/theme` and `core/constants`.
4. Screens read from `data/dummy`, never from inline lists. Real data will replace the dummy files later.
5. Features never import from other features. They only import from `core`, `data` and `shared`.
6. One widget per file, and the file is named after the widget.
