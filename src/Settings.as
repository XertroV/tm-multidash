


enum KeyboardShape
{
	Rectangle,
	Ellipse,
	Compact,
}

[Setting category="Keyboard" name="Shape"]
KeyboardShape Setting_Keyboard_Shape = KeyboardShape::Rectangle;

[Setting category="Keyboard" name="Empty fill color" color]
vec4 Setting_Keyboard_EmptyFillColor = vec4(0, 0, 0, 0.7f);

[Setting category="Keyboard" name="Fill color" color]
vec4 Setting_Keyboard_FillColor = vec4(1, 0.2f, 0.6f, 1);

[Setting category="Keyboard" name="Border color" color]
vec4 Setting_Keyboard_BorderColor = vec4(1, 1, 1, 1);

[Setting category="Keyboard" name="Border width" drag min=0 max=10]
float Setting_Keyboard_BorderWidth = 1.0f;

[Setting category="Keyboard" name="Border radius" drag min=0 max=50]
float Setting_Keyboard_BorderRadius = 2.0f;

[Setting category="Keyboard" name="Spacing" drag min=0 max=100]
float Setting_Keyboard_Spacing = 10.0f;

[Setting category="Keyboard" name="Inactive alpha" drag min=0 max=1]
float Setting_Keyboard_InactiveAlpha = 0.4f;
