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

/// Delegate protocol wrapping common touch events.
@objc public protocol AudioControlDelegate {
    
    /// The audio control's valud changed.
    @objc optional func audioControl(_ audioControl: AudioControl, valueChanged value: Float)
    
    /// Touches began inside the audio control.
    @objc optional func audioControlTouchesStarted(_ audioControl: AudioControl)
    
    /// Touches ended inside the audio control, either inside or outside.
    @objc optional func audioControlTouchesEnded(_ audioControl: AudioControl)
    
}

/// IBDesignable `UIControl` subclass which can be used as a base class for creating dials, pickers, sliders etc.
/// Subclasses must override `ratio(forLocation:)` and `path(forRatio:)`
@IBDesignable open class AudioControl: UIControl {
    
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
            sendActions(for: [.valueChanged])
        }
    }
    
    // MARK: Delegate
    
    /// The control's delegate.
    ///
    /// Declared as `AnyObject` to work around an Interface Builder bug.
    @IBOutlet public weak var delegate: AnyObject?
    
    private var audioControlDelegate: AudioControlDelegate? {
        return delegate as? AudioControlDelegate
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
        return scaleSteps.characters.split(separator: ",").map { Float(String($0))! }
    }
    
    // MARK: Formatter
    
    /// The control's formatter object, used for converting a generic value with arbitrary range to a user-readable string.
    /// The formatter object is dynamically generated, and depends upon `formatterString`, if `formatterType` is `"string"`, or `formatterSteps`, if `formatterType` is `"stepped"`.
    /// Invalid values for `formatterType` will fire a fatal error.
    internal var formatter: ParameterFormatter {
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
            let steps = NSDictionary(objects: formatterValues, forKeys: scaleValues as [NSCopying]) as! [Float: String]
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
        return formatterSteps.characters.split(separator: ",").map { String($0) }
    }
    
    // MARK: Font
    
    /// The control's font, used by the title label. Setting `fontName` or `fontSize` will update this value.
    internal var font: UIFont = .systemFont(ofSize: 12.0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The control's font name, used by the title label. This is split from `fontSize` as `@IBInspectable` does not support `UIFont` values.
    @IBInspectable public var fontName: String {
        set {
            font = UIFont(name: newValue, size: fontSize) ?? .systemFont(ofSize: fontSize)
        }
        get {
            return font.fontName
        }
    }
    
    /// The control's font size, used by the title label. This is split from `fontName` as `@IBInspectable` does not support `UIFont` values.
    @IBInspectable public var fontSize: CGFloat {
        set {
            font = UIFont(name: fontName, size: newValue) ?? .systemFont(ofSize: newValue)
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
        label.textAlignment = .center
        label.textColor = .protonomeBlack
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
    
    override open var isSelected: Bool {
        didSet {
            setNeedsLayout()
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            setNeedsLayout()
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setNeedsUpdateConstraints()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.text = title
        titleLabel.font = font
    }
    
    override open func updateConstraints() {
        super.updateConstraints()
        
        addSubview(titleLabel)
        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        titleLabel.snp.updateConstraints { make in
            make.left.equalTo(snp.leftMargin)
            make.right.equalTo(snp.rightMargin)
            make.bottom.equalTo(snp.bottomMargin)
        }
    }
    
    open override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.clear(rect)
        
        context.setFillColor(backgroundPathColor.cgColor)
        backgroundPath.fill()
        backgroundPath.addClip()
        
        context.setFillColor(foregroundPathColor.cgColor)
        foregroundPath.fill()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        addTarget(self, action: #selector(touchUp), for: .touchUpOutside)
    }
    
    internal func valueChanged() {
        audioControlDelegate?.audioControl?(self, valueChanged: self.value)
    }
    
    internal func touchDown() {
        audioControlDelegate?.audioControlTouchesStarted?(self)
    }
    
    internal func touchUp() {
        audioControlDelegate?.audioControlTouchesEnded?(self)
    }
    
    // MARK: - Touches
    
    private var touch: UITouch? {
        didSet {
            isSelected = touch != nil
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first
        
        if let location = touch?.location(in: self) {
            value = scale.value(for: ratio(for: location))
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touch?.location(in: self) {
            value = scale.value(for: ratio(for: location))
        }
        
        super.touchesMoved(touches, with: event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = nil
        
        super.touchesCancelled(touches, with: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = nil
        
        super.touchesEnded(touches, with: event)
    }
    
    // MARK: - Overrideables
    
    /**
     A method used to convert the current touch location into a useful ratio, in range `0.0...1.0`.
     Subclasses must override this method or a fatal error will fire.
     
     - parameter location: The touch location.
     
     - returns: A ratio, in range `0.0...1.0`.
     */
    open func ratio(for location: CGPoint) -> Float {
        fatalError("Subclasses of ParameterControl must override ratio(forLocation:)")
    }
    
    /**
     A method used to convert a ratio, in range `0.0...1.0`, into a bezier path used for the control's foreground, i.e. the indicator on a dial control.
     
     - parameter ratio: A ratio, in range `0.0...1.0`.
     
     - returns: A bezier path used for the control's foreground.
     */
    open func path(for ratio: Float) -> UIBezierPath {
        fatalError("Subclasses of ParameterControl must override path(forRatio:)")
    }
    
    // MARK: - Private getters
    
    private var hue: CGFloat {
        return CGFloat(scale.ratio(for: value).lerp(min: 215.0, max: 0.0) / 360.0)
    }
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
    
    private var backgroundPathColor: UIColor {
        if (isHighlighted || isSelected) {
            return .protonomeMedium(hue: hue)
        } else {
            return .protonomeDark(hue: hue)
        }
    }
    
    private var foregroundPath: UIBezierPath {
        return path(for: scale.ratio(for: value))
    }
    
    private var foregroundPathColor: UIColor {
        return .protonomeLight(hue: hue)
    }

}
