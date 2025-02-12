breed [ foods food ]
breed [ malemoths mmoth ]
breed [ femalemoths fmoth ]
breed [ bats bat ]

globals [
  food-size
  moth-size
  bat-size
]

malemoths-own [
  nearest-food
  distance-to-food
  nearest-femalemoth
  distance-to-femalemoth
  nearest-bat
  distance-to-bat
]

femalemoths-own [
  nearest-food
  distance-to-food
  nearest-malemoth
  distance-to-malemoth
  nearest-bat
  distance-to-bat
]

to setup
  clear-all
  set-default-shape foods "flower"
  set food-size 30
  set-default-shape malemoths "butterfly"
  set-default-shape femalemoths "butterfly"
  set moth-size 20
  set-default-shape bats "bird"
  set bat-size 50
  make-foods number-foods
  make-malemoths number-malemoths
  make-femalemoths number-femalemoths
  make-bats number-bats
  reset-ticks
end

to go
  ask malemoths [ malemoth-move ]
  ask femalemoths [ femalemoth-move ]
  ask bats [ bat-move ]
  tick
end

;;;;;;;;;;;;;;;;;;;;;;
;; Setup Procedures ;;
;;;;;;;;;;;;;;;;;;;;;;

to make-foods [ number ]
  create-foods number [
    set color green
    jump 10 + random-float (max-pxcor - 30)
    set size food-size
  ]
end

to make-malemoths [ number ]
  create-malemoths number [
    set color blue
    jump random-float max-pxcor
    set size moth-size
  ]
end

to make-femalemoths [ number ]
  create-femalemoths number [
    set color pink
    jump random-float max-pxcor
    set size moth-size
  ]
end

to make-bats [ number ]
  create-bats number [
    set color brown
    jump random-float max-pxcor
    set size bat-size
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;
;; Runtime Procedures ;;
;;;;;;;;;;;;;;;;;;;;;;;;

to malemoth-move    ;; turtle procedure
  ifelse number-foods > 0
  [
    set nearest-food min-one-of foods [distance myself]
    set distance-to-food distance nearest-food
  ]
  [
    set distance-to-food 1000
  ]
  ifelse number-femalemoths > 0
  [
    set nearest-femalemoth min-one-of femalemoths [distance myself]
    set distance-to-femalemoth distance nearest-femalemoth
  ]
  [
    set distance-to-femalemoth 1000
  ]
    ifelse number-bats > 0
  [
    set nearest-bat min-one-of bats [distance myself]
    set distance-to-bat distance nearest-bat
  ]
  [
    set distance-to-bat 1000
  ]
  if number-foods > 0 [
    face nearest-food
  ]
  if number-femalemoths > 0 [
    ifelse distance-to-food < distance-to-femalemoth * 0.5 AND number-bats = 0
    [ face nearest-food ]
    [ face nearest-femalemoth ]
  ]
  if number-bats > 0 AND distance-to-bat < bat-threshold [
    face min-one-of bats [distance myself]
    set heading (heading - 180)
  ]
  ifelse distance-to-food < 1 AND distance-to-femalemoth > 5 AND number-bats = 0
  [ right flutter-amount 5 forward 0]
  [ right flutter-amount 45 forward 1]
end

to femalemoth-move    ;; turtle procedure
  ifelse number-foods > 0
  [
    set nearest-food min-one-of foods [distance myself]
    set distance-to-food distance nearest-food
  ]
  [
    set distance-to-food 1000
  ]
  ifelse number-malemoths > 0
  [
    set nearest-malemoth min-one-of malemoths [distance myself]
    set distance-to-malemoth distance nearest-malemoth
  ]
  [
    set distance-to-malemoth 1000
  ]
    ifelse number-bats > 0
  [
    set nearest-bat min-one-of bats [distance myself]
    set distance-to-bat distance nearest-bat
  ]
  [
    set distance-to-bat 1000
  ]
  if number-foods > 0 [
    face nearest-food
  ]
  if number-malemoths > 0 [
    ifelse distance-to-food < distance-to-malemoth * 0.5 AND number-bats = 0
    [ face nearest-food ]
    [ face nearest-malemoth ]
  ]
  if number-bats > 0 AND distance-to-bat < bat-threshold [
    face min-one-of bats [distance myself]
    set heading (heading - 180)
  ]
  ifelse distance-to-food < 1 AND distance-to-malemoth > 5 AND number-bats = 0
  [ right flutter-amount 5 forward 0]
  [ right flutter-amount 45 forward 1]
end

to bat-move    ;; turtle procedure
  right flutter-amount 10
  forward 2
end

to-report flutter-amount [limit]
  ;; This routine takes a number as an input and returns a random value between
  ;; (+1 * input value) and (-1 * input value).
  ;; It is used to add a random flutter to the moth's movements
  report random-float (2 * limit) - limit
end


; Copyright 2025 Roger K. Moore
@#$#@#$#@
GRAPHICS-WINDOW
280
10
890
621
-1
-1
2.0
1
10
1
1
1
0
1
1
1
-150
150
-150
150
1
1
1
ticks
30.0

BUTTON
73
206
139
239
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
141
206
204
239
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
58
166
231
199
number-foods
number-foods
0
5
2.0
1
1
NIL
HORIZONTAL

SLIDER
58
90
230
123
number-malemoths
number-malemoths
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
58
55
230
88
number-femalemoths
number-femalemoths
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
57
258
229
291
bat-threshold
bat-threshold
0
200
150.0
1
1
NIL
HORIZONTAL

SLIDER
58
129
230
162
number-bats
number-bats
0
2
0.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This model demonstrates the principles of Rodney Brooks' subsumption architecture using his classis moths and bats example.

## HOW IT WORKS

The idea is that there are three layers of sumsumption.  In the lowest layer, moths seek food.  In the second layer, each moth will seek a mate if one is closer than the nearest food.  In the third layer, moths will avoid bats.

## HOW TO USE IT

Click the SETUP button to create NUMBER-FEMALEMOTHS, NUMBER-MALEMOTHS, NUMBER-BATS and NUMBER-FOODS. Click the GO button to start the simulation.

NUMBER-FEMALEMOTHS:  This slider determines how many female moths will be created when the SETUP button is pressed.

NUMBER-MALEMOTHS:  This slider determines how many male moths will be created when the SETUP button is pressed.

NUMBER-BATS:  This slider determines how many bats will be created when the SETUP button is pressed.

NUMBER-FOODS:  This slider determines how many food sources will be created when the SETUP button pressed.

BAT-THRESHOLD:  This slider influences how effective the bat is at repelling moths.

## RUNNING THE MODEL

First, run the simulation with one set of male or female moths.  Note that they simply flutter around.

Second, run the simulation with some food sources and one set of male or female moths.  Note that the moths converge on the food.

Third, run the simulation with both sets of moths and some food sources.  In this case, the male and female moths converge on each other as long as they are not too close to any food source.

Finally, run the simulation with a bat and vary the BAT-THRESHOLD.  The bat is ignored if BAT-THRESHOLD=0, but is avoided if BAT-THRESHOLD=150.

## RELATED MODELS

Ants, Ant Lines, Fireflies, Flocking, Moths

## CREDITS AND REFERENCES

Brooks, R. (1986). A robust layered control system for a mobile robot. IEEE Journal of Robotics and Automation, 2(1), 14-23.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Moore, R. K. (2025).  NetLogo Subsumption model.  School of Computer Science, University of Sheffield, UK.

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

bird
true
0
Polygon -7500403 true true 135 165 90 270 120 300 180 300 210 270 165 165
Rectangle -7500403 true true 120 105 180 237
Polygon -7500403 true true 135 105 120 75 105 45 121 6 167 8 207 25 257 46 180 75 165 105
Circle -16777216 true false 128 21 42
Polygon -7500403 true true 163 116 194 92 212 86 230 86 250 90 265 98 279 111 290 126 296 143 298 158 298 166 296 183 286 204 272 219 259 227 235 240 241 223 250 207 251 192 245 180 232 168 216 162 200 162 186 166 175 173 171 180
Polygon -7500403 true true 137 116 106 92 88 86 70 86 50 90 35 98 21 111 10 126 4 143 2 158 2 166 4 183 14 204 28 219 41 227 65 240 59 223 50 207 49 192 55 180 68 168 84 162 100 162 114 166 125 173 129 180

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

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

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
