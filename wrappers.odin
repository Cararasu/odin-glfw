package glfw

import bind "bindings"
import "core:strings"
import "core:mem" // for pointer-to-slice conversions

init :: #force_inline proc() -> bool { 
    return cast(bool)bind.Init();
}

terminate :: #force_inline proc() {
    bind.Terminate();
}

init_hint :: #force_inline proc(hint: Init_Hint, value: b32) { 
    bind.InitHint(cast(i32)hint, cast(i32)value);
}

get_version :: #force_inline proc() -> (int, int, int) { 
    major, minor, rev: i32;
    bind.GetVersion(&major, &minor, &rev);
    return cast(int)major, cast(int)minor, cast(int)rev;
}

get_error :: #force_inline proc() -> (cstring, Error) {
    desc: cstring;
    ret := bind.GetError(&desc);
    return desc, cast(Error)ret; // WARNING: may return nil
}

get_primary_monitor :: #force_inline proc() -> Monitor_Handle {
    return bind.GetPrimaryMonitor();
}

get_monitors :: #force_inline proc() -> []Monitor_Handle {
    count: i32;
    monitors := bind.GetMonitors(&count);
    return mem.slice_ptr(monitors, int(count));
}

get_monitor_pos :: #force_inline proc(monitor: Monitor_Handle) -> (int, int) {
    xpos, ypos: i32;
    bind.GetMonitorPos(monitor, &xpos, &ypos);
    return cast(int)xpos, cast(int)ypos;
}

get_monitor_physical_size :: #force_inline proc(monitor: Monitor_Handle) -> (int, int) {
    widthMM, heightMM: i32;
    bind.GetMonitorPos(monitor, &widthMM, &heightMM);
    return cast(int)widthMM, cast(int)heightMM;
}


get_monitor_content_scale :: #force_inline proc(monitor: Monitor_Handle) -> (f32, f32) {
    xscale, yscale: f32;
    bind.GetMonitorContentScale(monitor, &xscale, &yscale);
    return xscale, yscale;
}

set_monitor_user_pointer :: #force_inline proc(monitor: Monitor_Handle, pointer: rawptr) {
    bind.SetMonitorUserPointer(monitor, pointer);
}

get_monitor_user_pointer :: #force_inline proc(monitor: Monitor_Handle) -> rawptr {
    return bind.GetMonitorUserPointer(monitor);
}

get_video_mode :: #force_inline proc(monitor: Monitor_Handle) -> ^Vid_Mode {
    return bind.GetVideoMode(monitor);
}

set_gamma :: #force_inline proc(monitor: Monitor_Handle, gamma: f32) { 
    bind.SetGamma(monitor, gamma);
}

get_gamma_ramp :: #force_inline proc(monitor: Monitor_Handle) -> ^Gamma_Ramp {
    return bind.GetGammaRamp(monitor);
}

set_gamma_ramp :: #force_inline proc(monitor: Monitor_Handle, ramp: ^Gamma_Ramp) {
    bind.SetGammaRamp(monitor, ramp);
}

create_window :: #force_inline proc(width, height: int, title: string, monitor: Monitor_Handle, share: Window_Handle) -> Window_Handle {
    return bind.CreateWindow(cast(i32)width, cast(i32)height, strings.unsafe_string_to_cstring(title), monitor, share); // TODO: is this safe? 
}

destroy_window :: #force_inline proc(window: Window_Handle) {
    bind.DestroyWindow(window);
}

window_hint :: #force_inline proc(hint: Window_Attribute, value: int) { // NOTE: Some values might be enums, so cast those to ints. value can't bee made an enum because of things like GL versions
    bind.WindowHint(cast(i32)hint, cast(i32)value);
}

default_window_hints :: #force_inline proc() {
    bind.DefaultWindowHints();
}

window_hint_string :: #force_inline proc(hint: Window_Attribute, value: string) { 
    bind.WindowHintString(cast(i32)hint, strings.unsafe_string_to_cstring(value)); // TODO: is this safe? 
}

window_should_close :: #force_inline proc(window: Window_Handle) -> bool {
    return cast(bool)bind.WindowShouldClose(window);
}

swap_interval :: #force_inline proc(interval: int) {
    bind.SwapInterval(cast(i32)interval);
}

swap_buffers :: #force_inline proc(window: Window_Handle) {
    bind.SwapBuffers(window);
}

set_window_title :: #force_inline proc(window: Window_Handle, title: string) {
    bind.SetWindowTitle(window, strings.unsafe_string_to_cstring(title)); // TODO: is this safe?
}

set_window_icon :: #force_inline proc(window: Window_Handle, images: []Image) {
    bind.SetWindowIcon(window, cast(i32)len(images), &images[0]); // TODO: add nil safe-guard?
}

set_window_pos :: #force_inline proc(window: Window_Handle, xpos, ypos: int) {
    bind.SetWindowPos(window, cast(i32)xpos, cast(i32)ypos);
}

set_window_size_limits :: #force_inline proc(window: Window_Handle, minwidth, minheight, maxwidth, maxheight: int) {
    bind.SetWindowSizeLimits(window, cast(i32)minwidth, cast(i32)minheight, cast(i32)maxwidth, cast(i32)maxheight);

}

set_window_aspect_ratio :: #force_inline proc(window: Window_Handle, numer, denom: int) {
    bind.SetWindowAspectRatio(window, cast(i32)numer, cast(i32)denom);
}

set_window_size :: #force_inline proc(window: Window_Handle, width, height: int) {
    bind.SetWindowSize(window, cast(i32)width, cast(i32)height);
}

get_window_pos :: #force_inline proc(window: Window_Handle) -> (int, int) {
    xpos, ypos: i32;
    bind.GetWindowPos(window, &xpos, &ypos);
    return cast(int)xpos, cast(int)ypos;
}

get_window_size :: #force_inline proc(window: Window_Handle) -> (int, int) {
    width, height: i32;
    bind.GetWindowSize(window, &width, &height);
    return cast(int)width, cast(int)height;
}

get_framebuffer_size :: #force_inline proc(window: Window_Handle) -> (int, int) {
    width, height: i32;
    bind.GetFramebufferSize(window, &width, &height);
    return cast(int)width, cast(int)height;
}

get_window_frame_size :: #force_inline proc(window: Window_Handle) -> (int, int, int, int) {
    left, top, right, bottom: i32;
    bind.GetWindowFrameSize(window, &left, &top, &right, &bottom);
    return cast(int)left, cast(int)top, cast(int)right, cast(int)bottom;
}

get_window_content_scale :: #force_inline proc(window: Window_Handle) -> (f32, f32) { // TODO: convert to f64?
    xscale, yscale: f32;
    bind.GetWindowContentScale(window, &xscale, &yscale);
    return xscale, yscale;
}

get_window_opacity :: #force_inline proc(window: Window_Handle) -> f32 {
    return bind.GetWindowOpacity(window);
}

set_window_opacity :: #force_inline proc(window: Window_Handle, opacity: f32) {
    bind.SetWindowOpacity(window, opacity);
}

get_version_string :: #force_inline proc() -> string {
    return cast(string)bind.GetVersionString(); // TODO: is this safe?
}

get_monitor_name :: #force_inline proc(monitor: Monitor_Handle) -> string {
    return cast(string)bind.GetMonitorName(monitor); // TODO: is this safe?
}

get_clipboard_string :: #force_inline proc(window: Window_Handle) -> string {
    return cast(string)bind.GetClipboardString(window); // TODO: is this safe?
}

get_video_modes :: #force_inline proc(monitor: Monitor_Handle) -> []Vid_Mode {
    count: i32;
    data := bind.GetVideoModes(monitor, &count);
    return mem.slice_ptr(data, int(count));
}

get_key :: #force_inline proc(window: Window_Handle, key: Key) -> Key_State {
    return cast(Key_State)bind.GetKey(window, cast(i32)key); // NOTE: true == PRESS, false == RELEASE
}

get_key_name :: #force_inline proc(key: Key, scancode: int) -> string {
    return cast(string)bind.GetKeyName(cast(i32)key, cast(i32)scancode); // TODO: is this safe?
}

set_window_should_close :: #force_inline proc(window: Window_Handle, value: bool) {
    bind.SetWindowShouldClose(window, cast(i32)value);
}

joystick_present :: #force_inline proc(joy: Joystick) -> bool {
    return cast(bool)bind.JoystickPresent(cast(i32)joy);
}

vulkan_supported :: #force_inline proc() -> bool {
    return cast(bool)bind.VulkanSupported();
}

get_joystick_name :: #force_inline proc(joy: Joystick) -> string {
    return cast(string)bind.GetJoystickName(cast(i32)joy); // TODO: is this safe? (cstring -> string)
}

get_key_scancode :: #force_inline proc(key: int) -> int {
    return cast(int)bind.GetKeyScancode(cast(i32)key);
}

iconify_window :: #force_inline proc(window: Window_Handle) {
    bind.IconifyWindow(window);
}

minimize_window :: iconify_window;

restore_window :: #force_inline proc(window: Window_Handle) {
    bind.RestoreWindow(window);
}

maximize_window :: #force_inline proc(window: Window_Handle) {
    bind.MaximizeWindow(window);
}

show_window :: #force_inline proc(window: Window_Handle) {
    bind.ShowWindow(window);
}

hide_window :: #force_inline proc(window: Window_Handle) {
    bind.HideWindow(window);
}

focus_window :: #force_inline proc(window: Window_Handle) {
    bind.FocusWindow(window);
}

request_window_attention :: #force_inline proc(window: Window_Handle) {
    bind.RequestWindowAttention(window);
}

get_window_monitor :: #force_inline proc(window: Window_Handle) -> Monitor_Handle {
    return bind.GetWindowMonitor(window);
}

set_window_monitor :: #force_inline proc(window: Window_Handle, monitor: Monitor_Handle, xpos, ypos, width, height, refresh_rate: int) {
    bind.SetWindowMonitor(window, monitor, cast(i32)xpos, cast(i32)ypos, cast(i32)width, cast(i32)height, cast(i32)refresh_rate);
}

get_window_attrib :: #force_inline proc(window: Window_Handle, attrib: Window_Attribute) -> int { 
    return cast(int)bind.GetWindowAttrib(window, cast(i32)attrib);
}

set_window_user_pointer :: #force_inline proc(window: Window_Handle, pointer: rawptr) {
    bind.SetWindowUserPointer(window, pointer);
}

get_window_user_pointer :: #force_inline proc(window: Window_Handle) -> rawptr {
    return bind.GetWindowUserPointer(window);
}

set_window_attrib :: #force_inline proc(window: Window_Handle, attrib: Window_Attribute, value: int) {
    bind.SetWindowAttrib(window, cast(i32)attrib, cast(i32)value);
}

poll_events :: #force_inline proc() {
    bind.PollEvents();
}

wait_events :: #force_inline proc() {
    bind.WaitEvents();
}

wait_events_timeout :: #force_inline proc(timeout: f64) {
    bind.WaitEventsTimeout(timeout);
}

post_empty_event :: #force_inline proc() {
    bind.PostEmptyEvent();
}

get_input_mode :: #force_inline proc(window: Window_Handle, mode: Input_Mode) -> int {
    return cast(int)bind.GetInputMode(window, cast(i32)mode);
}

set_input_mode :: #force_inline proc(window: Window_Handle, mode: Input_Mode, value: int) {
    bind.SetInputMode(window, cast(i32)mode, cast(i32)value);
}

get_mouse_button :: #force_inline proc(window: Window_Handle, button: Mouse_Button) -> Button_State {
    return cast(Button_State)bind.GetMouseButton(window, cast(i32)button);
}

get_cursor_pos :: #force_inline proc(window: Window_Handle) -> (f64, f64) {
    xpos, ypos: f64;
    bind.GetCursorPos(window, &xpos, &ypos);
    return xpos, ypos;
}

set_cursor_pos :: #force_inline proc(window: Window_Handle, xpos, ypos: f64) {
    bind.SetCursorPos(window, xpos, ypos);
}

create_cursor :: #force_inline proc(image: ^Image, xhot, yhot: int) -> Cursor_Handle {
    return bind.CreateCursor(image, cast(i32)xhot, cast(i32)yhot);
}

destroy_cursor :: #force_inline proc(cursor: Cursor_Handle) {
    bind.DestroyCursor(cursor);
}

set_cursor :: #force_inline proc(window: Window_Handle, cursor: Cursor_Handle) {
    bind.SetCursor(window, cursor);
}

create_standard_cursor :: #force_inline proc(shape: Cursor_Shape) -> Cursor_Handle {
    return bind.CreateStandardCursor(cast(i32)shape);
}

get_joystick_axes :: #force_inline proc(joy: Joystick) -> []f32 {
    count: i32;
    data := bind.GetJoystickAxes(cast(i32)joy, &count);
    return mem.slice_ptr(data, int(count));
}

get_joystick_buttons :: #force_inline proc(joy: Joystick) -> []b8 { // NOTE: b8 instead of bool
    count: i32;
    data := bind.GetJoystickButtons(cast(i32)joy, &count);
    return mem.slice_ptr(cast(^b8)data, int(count));
}

get_joystick_hats :: #force_inline proc(jid: Joystick) -> []Joystick_Hat { 
    count: i32;
    data := bind.GetJoystickHats(cast(i32)jid, &count);
    return mem.slice_ptr(cast(^Joystick_Hat)data, int(count));
}

get_joystick_GUID :: #force_inline proc(jid: Joystick) -> string {
    return cast(string)bind.GetJoystickGUID(cast(i32)jid); // TODO: is this safe? (cstring -> string)
}

set_joystick_user_pointer :: #force_inline proc(jid: Joystick, pointer: rawptr) {
    bind.SetJoystickUserPointer(cast(i32)jid, pointer);
}

get_joystick_user_pointer :: #force_inline proc(jid: Joystick) -> rawptr {
    return bind.GetJoystickUserPointer(cast(i32)jid);
}

joystick_is_gamepad :: #force_inline proc(jid: Joystick) -> bool {
    return cast(bool)bind.JoystickIsGamepad(cast(i32)jid);
}

update_gamepad_mappings :: #force_inline proc(str: string) -> bool {
    return cast(bool)bind.UpdateGamepadMappings(strings.unsafe_string_to_cstring(str));
}

get_gamepad_name :: #force_inline proc(jid: Joystick) -> string {
    return cast(string)bind.GetGamepadName(cast(i32)jid);
}

get_gamepad_state :: #force_inline proc(jid: Joystick) -> (Gamepad_State, bool) {
    state: Gamepad_State;
    ret := cast(bool)bind.GetGamepadState(cast(i32)jid, &state);
    return state, ret;
}

set_clipboard_string :: #force_inline proc(window: Window_Handle, str: string) {
    if len(str) > 0 do bind.SetClipboardString(window, strings.unsafe_string_to_cstring(str)); // TODO: is this safe? (string -> cstring)
}

get_time :: #force_inline proc() -> f64 {
    return bind.GetTime();
}

set_time :: #force_inline proc(time: f64) {
    bind.SetTime(time);
}

get_timer_value :: #force_inline proc() -> u64 {
    return bind.GetTimerValue();
}

get_timer_frequency :: #force_inline proc() -> u64 {
    return bind.GetTimerFrequency();
}

make_context_current :: #force_inline proc(window: Window_Handle) {
    bind.MakeContextCurrent(window);
}

get_current_context :: #force_inline proc() -> Window_Handle {
    return bind.GetCurrentContext();
}

get_proc_address :: #force_inline proc(name: string) -> rawptr {
    return bind.GetProcAddress(strings.unsafe_string_to_cstring(name)); // TODO: is this safe? (string -> cstring)
}

extension_supported :: #force_inline proc(extension: string) -> bool { 
    return cast(bool)bind.ExtensionSupported(strings.unsafe_string_to_cstring(extension)); // TODO: is this safe?
}

set_monitor_callback :: #force_inline proc(cbfun: Monitor_Proc) -> Monitor_Proc {
    return bind.SetMonitorCallback(cbfun);
}

set_joystick_callback :: #force_inline proc(cbfun: Joystick_Proc) -> Joystick_Proc {
    return bind.SetJoystickCallback(cbfun);
}

set_window_iconify_callback :: #force_inline proc(window: Window_Handle, cbfun: Window_Iconify_Proc) -> Window_Iconify_Proc {
    return bind.SetWindowIconifyCallback(window, cbfun);
}

set_window_refresh_callback :: #force_inline proc(window: Window_Handle, cbfun: Window_Refresh_Proc) -> Window_Refresh_Proc {
    return bind.SetWindowRefreshCallback(window, cbfun);
}

set_window_focus_callback :: #force_inline proc(window: Window_Handle, cbfun: Window_Focus_Proc) -> Window_Focus_Proc {
    return bind.SetWindowFocusCallback(window, cbfun);
}

set_window_close_callback :: #force_inline proc(window: Window_Handle, cbfun: Window_Close_Proc) -> Window_Close_Proc {
    return bind.SetWindowCloseCallback(window, cbfun);
}

set_window_size_callback :: #force_inline proc(window: Window_Handle, cbfun: Window_Size_Proc) -> Window_Size_Proc {
    return bind.SetWindowSizeCallback(window, cbfun);
}

set_window_pos_callback :: #force_inline proc(window: Window_Handle, cbfun: Window_Pos_Proc) -> Window_Pos_Proc {
    return bind.SetWindowPosCallback(window, cbfun);
}

set_framebuffer_size_callback :: #force_inline proc(window: Window_Handle, cbfun: Framebuffer_Size_Proc) -> Framebuffer_Size_Proc {
    return bind.SetFramebufferSizeCallback(window, cbfun);
}

set_drop_callback :: #force_inline proc(window: Window_Handle, cbfun: Drop_Proc) -> Drop_Proc {
    return bind.SetDropCallback(window, cbfun);
}

set_window_maximize_callback :: #force_inline proc(window: Window_Handle, cbfun: Window_Maximize_Proc) -> Window_Maximize_Proc {
    return bind.SetWindowMaximizeCallback(window, cbfun);
}

set_window_content_scale_callback :: #force_inline proc(window: Window_Handle, cbfun: Window_Content_Scale_Proc) -> Window_Content_Scale_Proc {
    return bind.SetWindowContentScaleCallback(window, cbfun);
}

set_key_callback :: #force_inline proc(window: Window_Handle, cbfun: Key_Proc) -> Key_Proc {
    return bind.SetKeyCallback(window, cbfun);
}

set_mouse_button_callback :: #force_inline proc(window: Window_Handle, cbfun: Mouse_Button_Proc) -> Mouse_Button_Proc {
    return bind.SetMouseButtonCallback(window, cbfun);
}

set_cursor_pos_callback :: #force_inline proc(window: Window_Handle, cbfun: Cursor_Pos_Proc) -> Cursor_Pos_Proc {
    return bind.SetCursorPosCallback(window, cbfun);
}

set_scroll_callback :: #force_inline proc(window: Window_Handle, cbfun: Scroll_Proc) -> Scroll_Proc {
    return bind.SetScrollCallback(window, cbfun);
}

set_char_callback :: #force_inline proc(window: Window_Handle, cbfun: Char_Proc) -> Char_Proc {
    return bind.SetCharCallback(window, cbfun);
}

set_char_mods_callback :: #force_inline proc(window: Window_Handle, cbfun: Char_Mods_Proc) -> Char_Mods_Proc {
    return bind.SetCharModsCallback(window, cbfun);
}

set_cursor_enter_callback :: #force_inline proc(window: Window_Handle, cbfun: Cursor_Enter_Proc) -> Cursor_Enter_Proc {
    return bind.SetCursorEnterCallback(window, cbfun);
}

set_error_callback :: #force_inline proc(cbfun: Error_Proc) -> Error_Proc {
    return bind.SetErrorCallback(cbfun);
}


