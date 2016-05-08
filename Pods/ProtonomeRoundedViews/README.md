# ProtonomeRoundedViews

ProtonomeRoundedViews is a collection of IBDesignable-compatible views with rounded corners.

They are built with performance in mind, and avoid setting `layer.cornerRadius` in favor of using resizable images or overriding `drawRect:` instead. The reason for this being that calling `layer.cornerRadius` causes a layer to render its corners on the CPU, which can drastically lower your frame rate if, say, you do it a lot inside a scroll view.

Additionally, the views support `IBInspectable` and `IBDesignable` for configuration and preview in Interface Builder. 

## Classes

✓ UIView -> RoundedView
✓ UILabel -> RoundedLabel
✓ UIButton -> RoundedButton

## Todo

- Explore just setting `shouldRasterize` and `rasterizationScale`
- Explore using resizable images on `RoundedLayer` and `RoundedLabel`
