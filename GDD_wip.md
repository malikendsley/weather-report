# WEATHER REPORT
## Lore
You’re stuck aboard a vast space-preservatorium, home to multiple biomes, flora, and fauna with a state of the art weather manipulation system. Naturally, everything’s gone horribly wrong and the orbit is steadily decaying. This station was installed in orbit of SR-499 and sought to preserve the life that used to exist on the now-corrupt planet. It was corrupted due to a substance which is also under research at the same station, known as Flux
## Premise / Loop
* Wake up out of stasis with memory loss, shits going crazy
* Unknown benefactor helps you stabilize the immediate situation (gravity is messed up)
* Instructs you to wear the exclusion harness to help save yourself
* Progress through the game working your way to station core. Generally, you’re there to A) learn more about why you’re on this biological research station and B) Get to the center of the station to fire the sustainers and leave the station
* Along the way, collect suit upgrades and a clearance once you realize you need it


# Biomes
## The Furnace


Turns into an oasis in the wet season, significantly less dangerous

Dry season: fiery mess, very dangerous
The Freezer
Dry season: Taiga, boreal forest, more neutral.
Wet season: Frozen blizzardy mess, ice everywhere
The in-between
Not subject to weather control system
space station themed areas that connect everything


# Mechanics
## The ecosystem
## Seasons
The station is fundamentally a segmented ring of artificial ecosystems designed for experimentation and research. Because of this, a weather control system is built into the station. The player will be able to control the weather through this in order to accomplish their goals.

The weather will interact with as much of the gameplay as possible. Some possible things:
- Enemy turnout and behavior
- Visibility, movement speed
- Environmental hazards, presence or absence of certain gates

For example, some puzzles will need a certain weather condition to complete. 

### Food chain
The player is not the only thing on the space station. There will be a food chain, native residents of the artificial ecosystems might only bother the player out of self defense, or have preferred targets. 

In terms of gameplay, some enemies should be abnormally difficult (if not outright impossible) to kill with brute force. Bypassing these threats will either be ability gated or revolve around using their predictability.
## Health
Made of HP and armor pips
Armor block 4 instances of light damage each, 1 instance of heavy damage
Heavy damage only removes 1 pip regardless
Enemies can have any combination of heavy or light pips, encouraging specific combos
To reinforce this, pending playtesting, adjust hit-stun / recovery depending on whether hp and damage type matches
The player has normal hp pips. They might acquire armor pips (damage and statline system will be able to accommodate this regardless)
## Logistics
Dying will just place you back at either the nearest or the last checkpoint. It will reset minor stats, but keep major ones to make gameplay simple.
Kept
* Unlocks (bear in mind this requires a checkpoint near major unlocks)
Reset
* Enemy states
* Transient player state like statline
* Abilities and the clearance will be the keys

# Enemies

# The Ship AI
Taking this jam as an opportunity to field a simple dialogue system. Might cave and use something off the shelf. Probably not necessary though.

# Abilities
## Combat and Tools
> More Dakka = more exploded animals
### Service weapon
* 3 shots before a pause
* Alt fire is a charged beam weapon with the same pause
* Can charge while running
* Firing opposite of direction of movement will give small impulse

### Melee lunge
* Short cooldown if nothing hit, longer if something hit
* Tune to discourage melee repeats
* Enemies at one small pip
* Stagger?
* Follow up attack
* Refunds dash?

### Stasis grenade
* Stun enemies hit by initial blast, slow others, player completely immune
* Neutralizes velocity based hazards temporarily
* Parametric: If grenades are hard to get, this can’t gate anything important

# Traversal
### Warp Core
* Thrown to the same cursor as the Service Weapon
* At a certain distance deploy, hovering in the air moving more slowly (Ekko Q)
* If thrown below maximum range deploy at cursor
* If an enemy is hit before it deploys, it bounces a fixed distance and angle behind them, then deploys
* Recast to teleport to the core
* This maintains movement semantics as if you had jumped once (subject to change)
* Can recast as soon as it deploys or hits an enemy
* If recast after hitting an enemy, can deploy again

### Dash
* Fast and short
* Low-dash (forward downward input while running)
* Jump out of this for a higher jump
* Air-dash
* Faster at the start, slower at the end, holds vertical position until the dash ends, gravity starts again after
### One-Off
> Abilities whose use is gated by the presence of world elements. These are basically only used in this scenario, to add depth to traversal without any cognitive load on the player

### Grapple-able surfaces
* Designer tool to make temporarily non-traversable regions
### Sensitive electrical equipment
* Vulnerable to stasis grenades
### Substrate, frozen, lava, ice tiles
* Requires a certain season to be traversable

# User stories
* The scorch boss is weaker during the wet season and appears, but will not fight the player. However, the weather must be toggled to the dry season to leave the area, forcing the player to confront the boss at full power
* Some enemies have preferred targets that aren’t the player. Freezing a harmless enemy in stasis can distract an otherwise dangerous predator
* Normally, alt fire is not enough to enable flight for the player. A corridor “test” however consists of many floating enemies in a row that can be warp cored. The player will quickly discover they can’t quite bridge the gap with warp core alone. Between warps, they will have to alt fire downward (and maybe slightly behind them) to get in range of the next enemy. Tests like this are also ripe for being trivialized by either a one way lever or a horizontal traversal like grapple

# Roadmap
(Causal, not chronological)
### Mechanical Pass
> The end goal of this phase is to fully greybox the game. Once this phase is done, seriously reconsider any attempts to modify the gameplay besides tweaking levers.

### Vision Pass
> The end goal of this phase is to set the art direction and ensure all of the new systems laid out in the GDD are a) possible and b) not too time consuming.
Create the pipeline to either:
* Bake 3D assets to a spritesheet
* Display 3D assets on a 2D plane a la deadcells
Create pixel-grid quantized particle effects
Create a lighting tech room
### Asset Pass
> Enemies, fights, level layout, dialogue, and finer plot points will all be added here. This is the “meat” of the game, assembled from the tools manufactured in the mechanical pass. Pieces of the vision pass are also implemented here, though things like lighting may be deferred to the polish pass.
### Polish Pass
> What it says on the tin. Playtesting at this point is to make sure the gameplay experience is smooth. Implement controller support here, but conceptualize it in the mechanical pass to avoid writing yourself into a corner. Adding in some test bypasses might also serve weaker platformers.
# Asset Creation Workflow - tbd
