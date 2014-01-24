//
//  Mask.h
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#ifndef Game_Mask_h
#define Game_Mask_h

static const uint32_t CandyColisionBM = 0x0 << 0;
static const uint32_t NonTouchTrapColisionBM = 0x0 << 0;
static const uint32_t EnemyColBM = 0b;
static const uint32_t ColBM = 0b0001;



static const uint32_t kColisionRoom = 0b00011;
static const uint32_t kCollisionBox = 0b00101;
static const uint32_t kColisionTrap = 0b00111;
static const uint32_t kColisionEnemy = 0b00111;
static const uint32_t kColisionGirl = 0b11111;

static const uint32_t kContactFire = 0b00011;
static const uint32_t kContactCandy=0b11111;
static const uint32_t kContactTrap = 0b10001;
static const uint32_t kContactEnemy = 0b10001;
static const uint32_t kContactGirl = 0b11111;


#endif
