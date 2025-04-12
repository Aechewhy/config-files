-- Type definitions for LuaLS

--- @meta _

--- Love2D API root
---
--- @type table
love = nil

--- Base class for Balatro objects
---
--- @class Object
Object = {}

function Object.extend(base_class) end

--- @class Node: Object
Node = {}

function Node:init(args) end
function Node:update(dt) end
function Node:draw() end
function Node:draw_boundingrect() end

--- @class Moveable: Node
Moveable = {}

--- @class DynaText: Moveable
--- @field config any
--- @field shadow any
--- @field scale number
--- @field pop_in_rate number
--- @field bump_rate number
--- @field bump_amount number
--- @field font any
--- @field string any
DynaText = {}

--- @class UIBox: Moveable
UIBox = {}

--- @class UIElement: Moveable
UIElement = {}

--- @class Sprite: Moveable
Sprite = {}

--- @class AnimatedSprite: Sprite
AnimatedSprite = {}

--- @class Card: Moveable
Card = {}

--- @class CardArea: Moveable
CardArea = {}

--- @class Blind: Moveable
--- @field chips number|Big
--- @field config table
Blind = {}

--- @class Tag: Object
Tag = {}

--- @class Controller: Object
Controller = {}

--- @class Game: Object
--- @field VERSION string Game version
--- @field F_QUIT_BUTTON boolean
--- @field F_SKIP_TUTORIAL boolean
--- @field F_BASIC_CREDITS boolean
--- @field F_EXTERNAL_LINKS boolean
--- @field F_ENABLE_PERF_OVERLAY boolean
--- @field F_NO_SAVING boolean
--- @field F_MUTE boolean
--- @field F_SOUND_THREAD boolean
--- @field F_VIDEO_SETTINGS boolean
--- @field F_CTA boolean
--- @field F_VERBOSE boolean
--- @field F_HTTP_SCORES boolean
--- @field F_RUMBLE number?
--- @field F_CRASH_REPORTS boolean
--- @field F_NO_ERROR_HAND boolean
--- @field F_SWAP_AB_PIPS boolean
--- @field F_SWAP_AB_BUTTONS boolean
--- @field F_SWAP_XY_BUTTONS boolean
--- @field F_NO_ACHIEVEMENTS boolean
--- @field F_DISP_USERNAME nil|boolean|string
--- @field F_ENGLISH_ONLY boolean?
--- @field F_GUIDE boolean
--- @field F_JAN_CTA boolean
--- @field F_HIDE_BG boolean
--- @field F_TROPHIES boolean
--- @field F_PS4_PLAYSTATION_GLYPHS boolean
--- @field F_LOCAL_CLIPBOARD boolean
--- @field F_SAVE_TIMER number
--- @field F_MOBILE_UI boolean
--- @field F_HIDE_BETA_LANGS boolean?
--- @field F_DISCORD boolean?
--- @field SEED number
--- @field TIMERS {TOTAL: number, REAL: number, REAL_SHADER: number, UPTIME: number, BACKGROUND: number}
--- @field FRAMES {DRAW: number, MOVE: number}
--- @field exp_times {xy: number, scale: number, r: number}
--- @field SETTINGS table
--- @field COLLABS table
--- @field METRICS table
--- @field PROFILES table
--- @field TILESIZE number
--- @field TILESCALE number
--- @field TILE_W number
--- @field TILE_H number
--- @field DRAW_HASH_BUFF number
--- @field CARD_W number
--- @field CARD_H number
--- @field HIGHLIGHT_H number
--- @field COLLISION_BUFFER number
--- @field PITCH_MOD number
--- @field STATES {[string]: number} Enum of game states
--- @field STAGES {[string]: number} Enum of game stages
--- @field STAGE_OBJECTS table
--- @field STAGE number
--- @field STATE number
--- @field TAROT_INTERRUPT number? A game state
--- @field STATE_COMPLETE boolean
--- @field ARGS table
--- @field FUNCS table Callback functions
--- @field I table Instances of various objects
--- @field ANIMATION_ATLAS table
--- @field ASSET_ATLAS table
--- @field MOVEABLES table
--- @field ANIMATIONS table
--- @field DRAW_HASH Node[]
--- @field MIN_CLICK_DIST number
--- @field MIN_HOVER_TIME number
--- @field DEBUG boolean Whether debug drawing is enabled. Can be toggled by holding `g` and pressing `a` when not in
---                      release mode
--- @field ANIMATION_FPS number
--- @field VIBRATION number
--- @field CHALLENGE_WINS number
--- @field C table
--- @field UIT {[string]: number} Enum of UI element types
--- @field handlist string[] Array of poker hand types
--- @field button_mapping {a: string?, b: string?, x: string?, y: string?}
--- @field keybind_mapping {[string]: string}
---
--- @field SAVE_MANAGER table
--- @field HTTP_MANAGER table
--- @field SHADERS table
--- @field CONTROLLER Controller
---
--- @field shared_debuff Sprite
--- @field shared_soul Sprite
--- @field shared_undiscovered_joker Sprite
--- @field shared_undiscovered_tarot Sprite
--- @field shared_sticker_eternal Sprite
--- @field shared_sticker_perishable Sprite
--- @field shared_sticker_rental Sprite
--- @field shared_stickers {[string]: Sprite}
--- @field shared_seals {[string]: Sprite}
--- @field sticker_map string[]
---
--- @field STAGE_OBJECT_INTERRUPT boolean
--- @field CURSOR Sprite
---
--- @field E_MANAGER EventManager
--- @field SPEEDFACTOR number
---
--- @field P_SEALS {[string]: {order: number, discovered: boolean, set: string}}
--- @field P_TAGS {[string]: {name: string, set: string, discovered: boolean, min_ante: number?, order: number, config: table, requires: string?, pos: {x: number, y: number}}}
--- @field tag_undiscovered {name: string, order: number, config: table, pos: {x: number, y: number}}
--- @field P_STAKES {[string]: {name: string, unlocked: boolean, order: number, pos: {x: number, y: number}, stake_level: number, set: number}}
--- @field P_BLINDS {[string]: {name: string, defeated: boolean, order: number, dollars: number, mult: number, vars: table, debuff_text: string?, debuff: table, pos: {x: number, y: number}, boss: table?, boss_colour: Rgba?}}
--- @field b_undiscovered {name: string, debuff_text: string, pos: {x: number, y: number}}
--- @field P_CARDS {[string]: {name: string, value: string, suit: string, pos: {x: number, y: number}}}
--- @field j_locked {unlocked: boolean, max: number, name: string, pos: {x: number, y: number}, set: string, cost_mult: number, config: table}
--- @field v_locked {unlocked: boolean, max: number, name: string, pos: {x: number, y: number}, set: string, cost_mult: number, config: table}
--- @field c_locked {unlocked: boolean, max: number, name: string, pos: {x: number, y: number}, set: string, cost_mult: number, config: table}
--- @field j_undiscovered {unlocked: boolean, max: number, name: string, pos: {x: number, y: number}, set: string, cost_mult: number, config: table}
--- @field t_undiscovered {unlocked: boolean, max: number, name: string, pos: {x: number, y: number}, set: string, cost_mult: number, config: table}
--- @field p_undiscovered {unlocked: boolean, max: number, name: string, pos: {x: number, y: number}, set: string, cost_mult: number, config: table}
--- @field s_undiscovered {unlocked: boolean, max: number, name: string, pos: {x: number, y: number}, set: string, cost_mult: number, config: table}
--- @field v_undiscovered {unlocked: boolean, max: number, name: string, pos: {x: number, y: number}, set: string, cost_mult: number, config: table}
--- @field booster_undiscovered {unlocked: boolean, max: number, name: string, pos: {x: number, y: number}, set: string, cost_mult: number, config: table}
--- @field P_CENTERS {[string]: table}
--- @field P_CENTER_POOLS {[string]: table}
--- @field P_JOKER_RARITY_BOOLS table[]
--- @field P_LOCKED table
---
--- @field tagid number?
---
--- @field REFRESH_ALERTS boolean?
---
--- @field ROOM table?
---
--- @field last_blind {boss: boolean, name: string}?
---
--- @field GAME table? Game state, that gets serialized to a save file
--- @field SAVED_GAME string?
---
--- @field OVERLAY_MENU table?
---
--- @field play table?
--- @field hand table?
---
--- @field VIEWING_DECK boolean?
---
--- @field SCORING_COROUTINE thread From Talisman
Game = {}

--- Initialize a bunch of variables and constants on `Game`
function Game:set_globals() end

function Game:save_progress() end

--- Global `Game` object
---
--- @type Game: Object
G = nil

--- @class Event: Object
Event = {}

--- @class EventManager: Object
EventManager = {}

--- @param event Event
--- @param queue string?
--- @param front boolean?
function EventManager:add_event(event, queue, front) end

--- @param queue string?
--- @param exception string?
function EventManager:clear_queue(queue, exception) end

--- @alias Rgba {[1]: number, [2]: number, [3]: number, [4]: number}

--- @param hex string A hexadecimal color (without any leading #)
---
--- @return Rgba
--- @nodiscard
function HEX(hex) end

--- @param path string
---
--- @return string
function get_compressed(path) end

--- Eval a Lua string with an empty environment
---
--- Used for loading save data. Returns `nil` on failure.
---
--- @param str string
---
--- @return any?
function STR_UNPACK(str) end

--- @param args string|table
---
--- @return string
function localize(args, misc_cat) end

--- @param obj Node?
function add_to_drawhash(obj) end

--- Pushes and sets up the love graphics transform
---
--- Don't forget to call `love.graphics.pop()` when you're done
---
--- @param moveable Moveable
--- @param scale number
--- @param rotate number?
--- @param offset {x: number, y: number}?
function prep_draw(moveable, scale, rotate, offset) end

--- @param time number?
--- @param queue string?
function delay(time, queue) end

--- @return table
function get_starting_params() end

--- @param args table
function create_option_cycle(args) end

--- @param args table
function create_toggle(args) end

--- @return table
--- @nodiscard
function create_UIBox_game_over() end

--- Sound sources
---
--- @type {[string]: table}
SOURCES = nil

--- @type boolean
_RELEASE_MODE = nil
