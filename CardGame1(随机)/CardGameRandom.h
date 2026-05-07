#ifndef CARDGAMERANDOM_H
#define CARDGAMERANDOM_H

#include "Role.h"
#include "CGRTools.h"

namespace gamerandom {
	void SkillMP(Role*& ATK_Role, Role*& DMG_Role, int damage);

	void Player_AI(Role*& player, Role*& AI);

	void AI_Player(Role*& player, Role*& AI);

	bool GameOver(Role*& player, Role*& AI);

	bool chooseRole(const std::string judge_str_player, Role*& judge_Role, int mode);

	void setPlayer(Role*& player);

	void setAI(Role*& AI);

	int GameRandom();
}

#endif // !CARDGAMERANDOM_H