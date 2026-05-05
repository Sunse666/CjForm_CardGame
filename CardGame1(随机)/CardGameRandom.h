#ifndef CARDGAMERANDOM_H
#define CARDGAMERANDOM_H

#include "Role.h"
#include "CGRTools.h"

namespace gamerandom {
	void SkillMP(std::unique_ptr<Role>& ATK_Role, std::unique_ptr<Role>& DMG_Role, int damage);

	void Player_AI(std::unique_ptr<Role>& player,std::unique_ptr<Role>& AI);

	void AI_Player(std::unique_ptr<Role>& player,std::unique_ptr<Role>& AI);

	bool GameOver(std::unique_ptr<Role>& player, std::unique_ptr<Role>& AI);

	bool chooseRole(const std::string judge_str_player, std::unique_ptr<Role>& judge_Role, int mode);

	void setPlayer(std::unique_ptr<Role>& player);

	void setAI(std::unique_ptr<Role>& AI);

	int GameRandom();
}

#endif // !CARDGAMERANDOM_H