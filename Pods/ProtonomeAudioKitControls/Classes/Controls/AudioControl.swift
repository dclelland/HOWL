//
//  AudioControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Lerp
import SnapKit

/// IBDesignable `UIControl` subclass which can be used as a base class for creating dials, pickers, sliders etc.
/// Subclasses must override `ratio(forLocation:)` and `path(forRatio:)`
@IBDesignable public class AudioControl: UIControl {
    
    // MARK: - Properties
    
    // MARK: Title
    
    /// The control's title text, as displayed in the titleLabel.
    @IBInspectable public var title: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: Value
    
    /// The control's current value. Changing this triggers a new layout and display, and fires a `.ValueChanged` control event.
    @IBInspectable public var value: Float = 0.0 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
            sendActionsForControlEvents([.ValueChanged])
        }
    }
    
    // MARK: Scale
    
    /// The control's scale object, used for converting a generic ratio with range `0.0...1.0` (e.g. a slider's progress) to a useful value.
    /// The scale object is dynamically generated, and depends upon `scaleType`, plus either `scaleMin` and `scaleMax`, or `scaleSteps` if `scaleType` is `"stepped"`.
    /// Invalid values for `scaleType` will fire a fatal error.
    var scale: ParameterScale {
        guard let type = ScaleType(rawValue: scaleType) else {
            fatalError("Invalid scale type \"\(scaleType)\" in control with title \"\(title)\"")
        }
        
        switch type {
        case .Linear:
            return LinearParameterScale(minimum: scaleMin, maximum: scaleMax)
        case .Logarithmic:
            return LogarithmicParameterScale(minimum: scaleMin, maximum: scaleMax)
        case .Exponential:
            return ExponentialParameterScale(minimum: scaleMin, maximum: scaleMax, exponent: scaleExponent)
        case .Integer:
            return IntegerParameterScale(minimum: scaleMin, maximum: scaleMax)
        case .Stepped:
            return SteppedParameterScale(values: scaleValues)
        }
    }
    
    /// Default options for `scaleType`.
    public enum ScaleType: String {
        
        /// Specifies a `LinearParameterScale` object.
        case Linear = "linear"
        
        /// Specifies a `LogarithmicParameterScale` object.
        case Logarithmic = "logarithmic"
        
        /// Specifies a `ExponentialParameterScale` object.
        case Exponential = "exponential"
        
        /// Specifies an `IntegerParameterScale` object.
        case Integer = "integer"
        
        /// Specifies a `SteppedParameterScale` object.
        case Stepped = "stepped"
    }
    
    /// A string constant specifying the chosen scale.
    /// Due to the limitations of `@IBInspectable`, this must be set to one of the constants `"linear"`, `"logarithmic"`, `"exponential"`, `"integer"`, or `"stepped"`.
    @IBInspectable public var scaleType: String = ScaleType.Linear.rawValue {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// A minimum value, used by the linear, logarithmic, exponential, or integer scales.
    @IBInspectable public var scaleMin: Float = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// A maximum value, used by the linear, logarithmic, exponential, or integer scales.
    @IBInspectable public var scaleMax: Float = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// An exponent value, used by the exponential scale.
    @IBInspectable public var scaleExponent: Float = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// A sequence of steps, used by the stepped scale.
    /// Due to the limitations of `@IBInspectable`, this must be a comma-separated sequence of numbers, e.g.: "1.2,5.0,2.6,4.5".
    /// Invalid values will fire an exception.
    @IBInspectable public var scaleSteps: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var scaleValues: [Float] {
        return scaleSteps.characters.split(",").map { Float(String($0))! }
    }
    
    // MARK: Formatter
    
    /// The control's formatter object, used for converting a generic value with arbitrary range to a user-readable string.
    /// The formatter object is dynamically generated, and depends upon `formatterString`, if `formatterType` is `"string"`, or `formatterSteps`, if `formatterType` is `"stepped"`.
    /// Invalid values for `formatterType` will fire a fatal error.
    var formatter: ParameterFormatter {
        guard let type = FormatterType(rawValue: formatterType) else {
            fatalError("Invalid formatter type \"\(formatterType)\" in control with title \"\(title)\"")
        }
        
        switch type {
        case .Number:
            return NumberParameterFormatter()
        case .Integer:
            return IntegerParameterFormatter()
        case .Percentage:
            return PercentageParameterFormatter()
        case .Duration:
            return DurationParameterFormatter()
        case .Amplitude:
            return AmplitudeParameterFormatter()
        case .Frequency:
            return FrequencyParameterFormatter()
        case .String:
            return StringParameterFormatter(string: formatterString)
        case .Stepped:
            let steps = NSDictionary.init(objects: formatterValues, forKeys: scaleValues) as! [Float: String]
            return SteppedParameterFormatter(steps: steps)
        }
    }
    
    /// Default options for `formatterType`.
    public enum FormatterType: String {
        
        /// Specifies a `NumberParameterFormatter` object.
        case Number = "number"
        
        /// Specifies an `IntegerParameterFormatter` object.
        case Integer = "integer"
        
        /// Specifies a `PercentageParameterFormatter` object.
        case Percentage = "percentage"
        
        /// Specifies a `DurationParameterFormatter` object.
        case Duration = "duration"
        
        /// Specifies an `AmplitudeParameterFormatter` object.
        case Amplitude = "amplitude"
        
        /// Specifies a `FrequencyParameterFormatter` object.
        case Frequency = "frequency"
        
        /// Specifies a `StringParameterFormatter` object.
        case String = "string"
        
        /// Specifies a `SteppedParameterFormatter` object.
        case Stepped = "stepped"
    }
    
    /// A string constant specifying the chosen formatter.
    /// Due to the limitations of `@IBInspectable`, this must be set to one of the constants `"number"`, `"integer"`, `"percentage"`, `"duration"`, `"amplitude"`, `"frequency"`, `"string"`, or `"stepped"`.
    @IBInspectable public var formatterType: String = FormatterType.Number.rawValue {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// A custom string, used by the string formatter.
    @IBInspectable public var formatterString: String? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// A sequence of steps, used by the stepped formatter.
    /// Due to the limitations of `@IBInspectable`, this must be a comma-separated sequence of strings, e.g.: "Triangle,Square,Sawtooth".
    /// Invalid values will fire an exception.
    @IBInspectable public var formatterSteps: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var formatterValues: [String] {
        return formatterSteps.characters.split(",").map { String($0) }
    }
    
    // MARK: Font
    
    /// The control's font, used by the title label. Setting `fontName` or `fontSize` will update this value.
    var font: UIFont = UIFont.systemFontOfSize(12.0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The control's font name, used by the title label. This is split from `fontSize` as `@IBInspectable` does not support `UIFont` values.
    @IBInspectable public var fontName: String {
        set {
            font = UIFont(name: newValue, size: fontSize) ?? UIFont.systemFontOfSize(fontSize)
        }
        get {
            return font.fontName
        }
    }
    
    /// The control's font size, used by the title label. This is split from `fontName` as `@IBInspectable` does not support `UIFont` values.
    @IBInspectable public var fontSize: CGFloat {
        set {
            font = UIFont(name: fontName, size: newValue) ?? UIFont.systemFontOfSize(newValue)
        }
        get {
            return font.pointSize
        }
    }
    
    // MARK: Corner radius
    
    /// The control's corner radius. The radius given to the rounded rect created in `drawRect:`.
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Views
    
    /// The control's title label. Displays the contents of `title`.
    /// The constraints created for this label respect the layout margins, so they may be used to customise the padding around the title label.
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = UIColor.protonome_blackColor()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActions()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupActions()
    }
    
    // MARK: - Overrides
    
    override public var selected: Bool {
        didSet {
            setNeedsLayout()
        }
    }
    
    override public var highlighted: Bool {
        didSet {
            setNeedsLayout()
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setNeedsUpdateConstraints()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.text = title
        titleLabel.font = font
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        addSubview(titleLabel)
        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        titleLabel.snp_updateConstraints { make in
            make.left.equalTo(self.snp_leftMargin)
            make.right.equalTo(self.snp_rightMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
    }
    
    public override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(context, rect)
        
        CGContextSetFillColorWithColor(context, backgroundPathColor.CGColor)
        backgroundPath.fill()
        backgroundPath.addClip()
        
        CGContextSetFillColorWithColor(context, foregroundPathColor.CGColor)
        foregroundPath.fill()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        addTarget(self, action: #selector(didChangeValue), forControlEvents: .ValueChanged)
        addTarget(self, action: #selector(didTouchDown), forControlEvents: .TouchDown)
        addTarget(self, action: #selector(didTouchUp), forControlEvents: .TouchUpInside)
        addTarget(self, action: #selector(didTouchUp), forControlEvents: .TouchUpOutside)
    }
    
    /// A callback block, called when a `.ValueChanged` control event fires, i.e. when `value` is set.
    public var onChangeValue: ((value: Float) -> Void)?
    
    internal func didChangeValue() {
        onChangeValue?(value: value)
    }
    
    /// A callback block, called when a `.TouchDown` control event fires, i.e. when the control is selected.
    public var onTouchDown: (Void -> Void)?
    
    internal func didTouchDown() {
        onTouchDown?()
    }
    
    /// A callback block, called when a `.TouchUpInside` or `.TouchUpOutside` control event fires, i.e. when the control is de-selected.
    public var onTouchUp: (Void -> Void)?
    
    internal func didTouchUp() {
        onTouchUp?()
    }
    
    // MARK: - Touches
    
    private var touch: UITouch? {
        didSet {
            selected = touch != nil
        }
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = touches.first
        
        if let location = touch?.locationInView(self) {
            value = scale.value(forRatio: ratio(forLocation: location))
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touch?.locationInView(self) {
            value = scale.value(forRatio: ratio(forLocation: location))
        }
        
        super.touchesMoved(touches, withEvent: event)
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touch = nil
        
        super.touchesCancelled(touches, withEvent: event)
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = nil
        
        super.touchesEnded(touches, withEvent: event)
    }
    
    // MARK: - Overrideables
    
    /**
     A method used to convert the current touch location into a useful ratio, in range `0.0...1.0`.
     Subclasses must override this method or a fatal error will fire.
     
     - parameter location: The touch location.
     
     - returns: A ratio, in range `0.0...1.0`.
     */
    public func ratio(forLocation location: CGPoint) -> Float {
        fatalError("Subclasses of ParameterControl must override ratio(forLocation:)")
    }
    
    /**
     A method used to convert a ratio, in range `0.0...1.0`, into a bezier path used for the control's foreground, i.e. the indicator on a dial control.
     
     - parameter ratio: A ratio, in range `0.0...1.0`.
     
     - returns: A bezier path used for the control's foreground.
     */
    public func path(forRatio ratio: Float) -> UIBezierPath {
        fatalError("Subclasses of ParameterControl must override path(forRatio:)")
    }
    
    // MARK: - Private getters
    
    private var hue: CGFloat {
        return CGFloat(scale.ratio(forValue: value).lerp(min: 215.0, max: 0.0) / 360.0)
    }
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
    
    private var backgroundPathColor: UIColor {
        if (highlighted || selected) {
            return UIColor.protonome_mediumColor(withHue: hue)
        } else {
            return UIColor.protonome_darkColor(withHue: hue)
        }
    }
    
    private var foregroundPath: UIBezierPath {
        return path(forRatio: scale.ratio(forValue: value))
    }
    
    private var foregroundPathColor: UIColor {
        return UIColor.protonome_lightColor(withHue: hue)
    }

}
