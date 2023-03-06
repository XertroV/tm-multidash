bool UserHasPermissions = false;

void Main() {
    startnew(MainCoro);
}

void MainCoro() {
    while (true) {
        yield();
    }
}

int g_NvgFont = nvg::LoadFont("DroidSans.ttf", true, true);


/** Render function called every frame.
*/
void Render() {
    if (!ShowWindow) return;
    if (GetApp().GameScene is null) return;
    nvg::Reset();
    nvg::FontFace(g_NvgFont);
    auto @viss = VehicleState::GetAllVis(GetApp().GameScene);
    for (uint i = 0; i < viss.Length; i++) {
        auto vis = viss[i];
        auto ssPos = Camera::ToScreen(vis.AsyncState.Position);
        auto abovePos = Camera::ToScreen(vis.AsyncState.Position + vec3(0, .1, 0));
        if (ssPos.z > 0 || abovePos.z > 0) continue;
        // auto scale = (ssPos.xy - abovePos.xy).LengthSquared() ** .15;
        float scale = 3;
        // todo: dial this in
        float screenScale = 30.0;
        nvg::Translate(ssPos.xy);
        DrawInputs(vis.AsyncState, vec2(scale * 2., scale) * screenScale);
        nvg::ResetTransform();
    }
}

float padding = -1;

void DrawInputs(CSceneVehicleVisState@ vis, const vec2 &in size) {
    if (padding < 0) padding = float(Draw::GetHeight()) * 0.004;
    // float _padding =

    float steerLeft = vis.InputSteer < 0 ? Math::Abs(vis.InputSteer) : 0.0f;
    float steerRight = vis.InputSteer > 0 ? vis.InputSteer : 0.0f;

    vec2 keySize = vec2((size.x - padding * 2) / 3, (size.y - padding) / 2);
    vec2 sideKeySize = keySize;

    vec2 upPos = vec2(keySize.x + padding, 0);
    vec2 downPos = vec2(keySize.x + padding, keySize.y + padding);
    vec2 leftPos = vec2(0, keySize.y + padding);
    vec2 rightPos = vec2(keySize.x * 2 + padding * 2, keySize.y + padding);

    nvg::Translate(size * -1);
    RenderKey(upPos, keySize, Icons::AngleUp, vis.InputGasPedal);
    RenderKey(downPos, keySize, Icons::AngleDown, vis.InputIsBraking ? 1.0f : vis.InputBrakePedal);

    RenderKey(leftPos, sideKeySize, Icons::AngleLeft, steerLeft, -1);
    RenderKey(rightPos, sideKeySize, Icons::AngleRight, steerRight, 1);
}

enum InputTy { Right = 0, Up, Left, Down }

void RenderKey(const vec2 &in pos, const vec2 &in size, const string &in text, float value, int fillDir = 0) {
    // float orientation = Math::ToRad(float(int(ty)) * Math::PI / 2.0);
	vec4 borderColor = Setting_Keyboard_BorderColor;
    if (fillDir == 0) {
        borderColor.w *= Math::Abs(value) > 0.1f ? 1.0f : Setting_Keyboard_InactiveAlpha;
    } else {
        borderColor.w *= Math::Lerp(Setting_Keyboard_InactiveAlpha, 1.0f, value);
    }

    nvg::BeginPath();
    nvg::StrokeWidth(Setting_Keyboard_BorderWidth);

    switch (Setting_Keyboard_Shape) {
        case KeyboardShape::Rectangle:
        case KeyboardShape::Compact:
            nvg::RoundedRect(pos.x, pos.y, size.x, size.y, Setting_Keyboard_BorderRadius);
            break;
        case KeyboardShape::Ellipse:
            nvg::Ellipse(pos + size / 2, size.x / 2, size.y / 2);
            break;
    }

    nvg::FillColor(Setting_Keyboard_EmptyFillColor);
    nvg::Fill();

    if (fillDir == 0) {
        if (Math::Abs(value) > 0.1f) {
            nvg::FillColor(Setting_Keyboard_FillColor);
            nvg::Fill();
        }
    } else if (value > 0) {
        if (fillDir == -1) {
            float valueWidth = value * size.x;
            nvg::Scissor(size.x - valueWidth, pos.y, valueWidth, size.y);
        } else if (fillDir == 1) {
            float valueWidth = value * size.x;
            nvg::Scissor(pos.x, pos.y, valueWidth, size.y);
        }
        nvg::FillColor(Setting_Keyboard_FillColor);
        nvg::Fill();
        nvg::ResetScissor();
    }

    nvg::StrokeColor(borderColor);
    nvg::Stroke();

    nvg::BeginPath();
    nvg::FontFace(g_NvgFont);
    nvg::FontSize(size.x / 2);
    nvg::FillColor(borderColor);
    nvg::TextAlign(nvg::Align::Middle | nvg::Align::Center);
    nvg::TextBox(pos.x, pos.y + size.y / 2, size.x, text);
}



void Notify(const string &in msg) {
    UI::ShowNotification(Meta::ExecutingPlugin().Name, msg);
    trace("Notified: " + msg);
}

void NotifyError(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Error", msg, vec4(.9, .3, .1, .3), 15000);
}

void NotifyWarning(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Warning", msg, vec4(.9, .6, .2, .3), 15000);
}

const string PluginIcon = Icons::KeyboardO;
const string MenuTitle = "\\$f19" + PluginIcon + "\\$z " + Meta::ExecutingPlugin().Name;

// show the window immediately upon installation
[Setting hidden]
bool ShowWindow = true;

/** Render function called every frame intended only for menu items in `UI`. */
void RenderMenu() {
    if (UI::MenuItem(MenuTitle, "", ShowWindow)) {
        ShowWindow = !ShowWindow;
    }
}

void AddSimpleTooltip(const string &in msg) {
    if (UI::IsItemHovered()) {
        UI::BeginTooltip();
        UI::Text(msg);
        UI::EndTooltip();
    }
}
