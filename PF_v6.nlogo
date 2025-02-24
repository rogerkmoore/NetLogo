globals [
  redbeaconxcor redbeaconycor
  greenbeaconxcor greenbeaconycor
  bluebeaconxcor bluebeaconycor
  fieldxcor fieldycor
]

patches-own [
  direction
  strength
  redness
  greeness
  blueness
]

;;;;;;;;;;;;;;;;;;;;;;
;; Setup Procedures ;;
;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all

  ;; set up turtles
  create-turtles 4 [ set size 20 ]

  ;; configure each turtle differently
  ask turtle 0 [ set color white set xcor -170 + random 340 set ycor -170 + random 340 ]
  ask turtle 1 [ set shape "ufo top" set color red set xcor -170 + random 340 set ycor -170 + random 340 ]
  ask turtle 2 [ set shape "ufo top" set color green set xcor -170 + random 340 set ycor -170 + random 340 ]
  ask turtle 3 [ set shape "ufo top" set color blue set xcor -170 + random 340 set ycor -170 + random 340 ]


  ;; remember where the beacons are
  ask turtle 1 [ set redbeaconxcor xcor set redbeaconycor ycor ]
  ask turtle 2 [ set greenbeaconxcor xcor set greenbeaconycor ycor ]
  ask turtle 3 [ set bluebeaconxcor xcor set bluebeaconycor ycor ]


  ;; compute and display the field
  populatefield
  displayfield

  reset-ticks
end


;;;;;;;;;;;;;;;;;;;;;;;;
;; Runtime Procedures ;;
;;;;;;;;;;;;;;;;;;;;;;;;

to go
  ;; allow the robot to be moved manually using the mouse
  if mouse-down? [
    if MouseSelector = "Robot" [ask turtle 0 [ set xcor mouse-xcor set ycor mouse-ycor] ]
    if MouseSelector = "RedBeacon" [ask turtle 1 [ set xcor mouse-xcor set ycor mouse-ycor set redbeaconxcor xcor set redbeaconycor ycor ] ]
    if MouseSelector = "GreenBeacon" [ask turtle 2 [ set xcor mouse-xcor set ycor mouse-ycor set greenbeaconxcor xcor set greenbeaconycor ycor] ]
    if MouseSelector = "BlueBeacon" [ask turtle 3 [ set xcor mouse-xcor set ycor mouse-ycor set bluebeaconxcor xcor set bluebeaconycor ycor] ]

  ]

  ;; compute and display the field
  populatefield
  displayfield

  ;; make the robot face the direction stored in its current patch
  ;; and move forward at a speed depending on the strength of the field
  ask turtle 0 [
    set heading [direction] of patch-here
    fd [strength * RobotSpeed] of patch-here
  ]

  tick
end

to populatefield
  ;; populate the potential field with directions and strengths
  ask patches [
    ;; compute the local field vector
    set fieldxcor redbeaconWeight * (redbeaconxcor - pxcor) / (1 + distance turtle 1)
    + greenbeaconWeight * (greenbeaconxcor - pxcor) / (1 + distance turtle 2)
    + bluebeaconWeight * (bluebeaconxcor - pxcor) / (1 + distance turtle 3)
    set fieldycor redbeaconWeight * (redbeaconycor - pycor) / (1 + distance turtle 1)
    + greenbeaconWeight * (greenbeaconycor - pycor) / (1 + distance turtle 2)
    + bluebeaconWeight * (bluebeaconycor - pycor) / (1 + distance turtle 3)
    ;; convert to polar coordinates
    if fieldxcor != 0 OR fieldycor != 0 [ set direction atan (fieldxcor) (fieldycor) ]
    set strength ((fieldxcor ^ 2) + (fieldycor ^ 2)) ^ 0.5
  ]
end

to displayfield
  ask patches [
    ;; set the appropriate colour for each patch
    ;; red = 0 degrees, green = 120 degrees, blue = 240 degrees
    if direction >= 180 AND direction <= 360 [ set redness strength * (direction - 180) * 255 / 180 ]
    if direction >= 0 AND direction <= 180 [ set redness strength * (180 - direction) * 255 / 180 ]
    if direction >= 300 AND direction <= 360 [ set greeness strength * (direction - 300) * 255 / 180 ]
    if direction >= 0 AND direction <= 120 [ set greeness strength * (direction + 60) * 255 / 180 ]
    if direction >= 120 AND direction <= 300 [ set greeness strength * (300 - direction) * 255 / 180 ]
    if direction >= 60 AND direction <= 240 [ set blueness strength * (direction - 60) * 255 / 180 ]
    if direction >= 240 AND direction <= 360 [ set blueness strength * (420 - direction) * 255 / 180 ]
    if direction >= 0 AND direction <= 60 [ set blueness strength * (60 - direction) * 255 / 180 ]
    set pcolor rgb redness greeness blueness
  ]
end

; Copyright 2025 Roger K. Moore
@#$#@#$#@
GRAPHICS-WINDOW
280
10
829
560
-1
-1
1.5
1
10
1
1
1
0
0
0
1
-180
180
-180
180
1
1
1
ticks
30.0

BUTTON
60
32
126
65
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
140
32
203
65
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
48
87
220
120
RedBeaconWeight
RedBeaconWeight
-1
1
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
48
120
220
153
GreenBeaconWeight
GreenBeaconWeight
-1
1
0.0
0.1
1
NIL
HORIZONTAL

CHOOSER
69
201
207
246
MouseSelector
MouseSelector
"Robot" "RedBeacon" "GreenBeacon" "BlueBeacon"
0

SLIDER
51
257
223
290
RobotSpeed
RobotSpeed
0
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
48
153
220
186
BlueBeaconWeight
BlueBeaconWeight
-1
1
0.0
0.1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This model demonstrates the principle of a 'potential field' for directing a robot's movement.  The model consists of a 'robot' (white arrow) and three 'beacons' (red, green and blue).  Each beacon can be configuerd to be an 'attractor' (+ve weight) or a 'repulsor' (-ve weight).  The robot moves from its initial position towards attractors and away from repulsors.  The route taken depends on the relative strengths of the individual attractor and repulsor fields.

## HOW IT WORKS

Attractors generate a field with vectors directed towards them and repulsors generate a field with vectors directed away from them.  As well as the weight assigned to each beacon in the interface, the strength of each vector is inversely proportional to the distance from the respective beacon.  Vector fields from all three beacons are added together to form the overall potential field in which the local direction and stength of the field is indicated by the local background colour and density.  Red indicates vectors pointing north (0 degrees), green indicates vectors pointing south-east (120 degrees) and blue indicates vectors pointing south-west (240 degrees).  The strength of the field influences the speed of the robot, which means that dark areas not only show where fields have cancelled each other out, but they also represent 'local minima' where the robot will move slowly or even become stuck.

## HOW TO USE IT

Pressing the SETUP button randomly places the robot and three beacons in the space and creates the initial potential field as a function of their relative strengths as set using the three ***WEIGHT sliders.  Pressing GO sets the robot in motion at an overall rate determined by ROBOTSPEED.  The robot or any of the beacons may be moved manually using MOUSESELECTOR.  Note that the field adjusts dynamically, so it is easy to see the implcations of particular configurations.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Moore, R. K. (2025).  Potential Fields.  School of Computer Science, University of Sheffield, UK.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2025 Roger K. Moore.

<!-- 2025 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bee 2
true
0
Polygon -1184463 true false 195 150 105 150 90 165 90 225 105 270 135 300 165 300 195 270 210 225 210 165 195 150
Rectangle -16777216 true false 90 165 212 185
Polygon -16777216 true false 90 207 90 226 210 226 210 207
Polygon -16777216 true false 103 266 198 266 203 246 96 246
Polygon -6459832 true false 120 150 105 135 105 75 120 60 180 60 195 75 195 135 180 150
Polygon -6459832 true false 150 15 120 30 120 60 180 60 180 30
Circle -16777216 true false 105 30 30
Circle -16777216 true false 165 30 30
Polygon -7500403 true true 120 90 75 105 15 90 30 75 120 75
Polygon -16777216 false false 120 75 30 75 15 90 75 105 120 90
Polygon -7500403 true true 180 75 180 90 225 105 285 90 270 75
Polygon -16777216 false false 180 75 270 75 285 90 225 105 180 90
Polygon -7500403 true true 180 75 180 90 195 105 240 195 270 210 285 210 285 150 255 105
Polygon -16777216 false false 180 75 255 105 285 150 285 210 270 210 240 195 195 105 180 90
Polygon -7500403 true true 120 75 45 105 15 150 15 210 30 210 60 195 105 105 120 90
Polygon -16777216 false false 120 75 45 105 15 150 15 210 30 210 60 195 105 105 120 90
Polygon -16777216 true false 135 300 165 300 180 285 120 285

bird
true
0
Polygon -7500403 true true 135 165 90 270 120 300 180 300 210 270 165 165
Rectangle -7500403 true true 120 105 180 237
Polygon -7500403 true true 135 105 120 75 105 45 121 6 167 8 207 25 257 46 180 75 165 105
Circle -16777216 true false 128 21 42
Polygon -7500403 true true 163 116 194 92 212 86 230 86 250 90 265 98 279 111 290 126 296 143 298 158 298 166 296 183 286 204 272 219 259 227 235 240 241 223 250 207 251 192 245 180 232 168 216 162 200 162 186 166 175 173 171 180
Polygon -7500403 true true 137 116 106 92 88 86 70 86 50 90 35 98 21 111 10 126 4 143 2 158 2 166 4 183 14 204 28 219 41 227 65 240 59 223 50 207 49 192 55 180 68 168 84 162 100 162 114 166 125 173 129 180

bird side
false
0
Polygon -7500403 true true 0 120 45 90 75 90 105 120 150 120 240 135 285 120 285 135 300 150 240 150 195 165 255 195 210 195 150 210 90 195 60 180 45 135
Circle -16777216 true false 38 98 14

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 16 16 270
Circle -16777216 true false 46 46 210

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

hawk
true
0
Polygon -7500403 true true 151 170 136 170 123 229 143 244 156 244 179 229 166 170
Polygon -16777216 true false 152 154 137 154 125 213 140 229 159 229 179 214 167 154
Polygon -7500403 true true 151 140 136 140 126 202 139 214 159 214 176 200 166 140
Polygon -16777216 true false 151 125 134 124 128 188 140 198 161 197 174 188 166 125
Polygon -7500403 true true 152 86 227 72 286 97 272 101 294 117 276 118 287 131 270 131 278 141 264 138 267 145 228 150 153 147
Polygon -7500403 true true 160 74 159 61 149 54 130 53 139 62 133 81 127 113 129 149 134 177 150 206 168 179 172 147 169 111
Circle -16777216 true false 144 55 7
Polygon -16777216 true false 129 53 135 58 139 54
Polygon -7500403 true true 148 86 73 72 14 97 28 101 6 117 24 118 13 131 30 131 22 141 36 138 33 145 72 150 147 147

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

lander 2
true
0
Polygon -7500403 true true 135 205 120 235 180 235 165 205
Polygon -16777216 false false 135 205 120 235 180 235 165 205
Line -7500403 true 75 30 195 30
Polygon -7500403 true true 195 150 210 165 225 165 240 150 240 135 225 120 210 120 195 135
Polygon -16777216 false false 195 150 210 165 225 165 240 150 240 135 225 120 210 120 195 135
Polygon -7500403 true true 75 75 105 45 195 45 225 75 225 135 195 165 105 165 75 135
Polygon -16777216 false false 75 75 105 45 195 45 225 75 225 120 225 135 195 165 105 165 75 135
Polygon -16777216 true false 217 90 210 75 180 60 180 90
Polygon -16777216 true false 83 90 90 75 120 60 120 90
Polygon -16777216 false false 135 165 120 135 135 75 150 60 165 75 180 135 165 165
Circle -7500403 true true 120 15 30
Circle -16777216 false false 120 15 30
Line -7500403 true 150 0 150 45
Polygon -1184463 true false 90 165 105 210 195 210 210 165
Line -1184463 false 210 165 245 239
Line -1184463 false 237 221 194 207
Rectangle -1184463 true false 221 245 261 238
Line -1184463 false 90 165 55 239
Line -1184463 false 63 221 106 207
Rectangle -1184463 true false 39 245 79 238
Polygon -16777216 false false 90 165 105 210 195 210 210 165
Rectangle -16777216 false false 221 237 262 245
Rectangle -16777216 false false 38 237 79 245

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

ufo top
false
0
Circle -1 true false 15 15 270
Circle -16777216 false false 15 15 270
Circle -7500403 true true 75 75 150
Circle -16777216 false false 75 75 150
Circle -7500403 true true 60 60 30
Circle -7500403 true true 135 30 30
Circle -7500403 true true 210 60 30
Circle -7500403 true true 240 135 30
Circle -7500403 true true 210 210 30
Circle -7500403 true true 135 240 30
Circle -7500403 true true 60 210 30
Circle -7500403 true true 30 135 30
Circle -16777216 false false 30 135 30
Circle -16777216 false false 60 210 30
Circle -16777216 false false 135 240 30
Circle -16777216 false false 210 210 30
Circle -16777216 false false 240 135 30
Circle -16777216 false false 210 60 30
Circle -16777216 false false 135 30 30
Circle -16777216 false false 60 60 30

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
