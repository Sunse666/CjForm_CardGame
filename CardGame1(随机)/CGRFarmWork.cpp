#include "CardGameRandom.h"

namespace gamerandom {
	void SkillMP(Role*& ATK_Role, Role*& DMG_Role,int ChangeMP) {
		ATK_Role->changeMP(ChangeMP*2);
		DMG_Role->changeMP(ChangeMP);
	}

	void showPlayer_AI(Role*& player, Role*& AI) {
		tools::out(std::string("当前玩家HP:") + std::to_string(player->getHP()));
		tools::out(std::string("当前AIHP:") + std::to_string(AI->getHP()));
	}

	void Player_AI(Role*& player, Role*& AI) {
		tools::System("cls");
		tools::out(std::string("玩家回合"));
		showPlayer_AI(player, AI);
		player->choose();
		int ATK = player->skill();
		AI->changeHP(ATK);
		SkillMP(player, AI, ATK);
		tools::out(std::string("玩家回合结束"));
		tools::out(std::string("当前MP:") + std::to_string(player->getMP()));
		showPlayer_AI(player, AI);
	}

	void AI_Player(Role*& player, Role* & AI) {
		tools::System("cls");
		tools::out(std::string("AI回合"));
		showPlayer_AI(player, AI);
		AI->choose();
		int ATK = AI->skill();
		player->changeHP(ATK);
		SkillMP(AI, player, ATK);
		tools::out(std::string("AI回合结束"));
		tools::out(std::string("当前MP:") + std::to_string(player->getMP()));
		showPlayer_AI(player,AI);
	}

	bool GameOver(Role*& player, Role*& AI) {
		if (AI->getHP() < 0) {
			tools::out(std::string("玩家胜利\n游戏结束"));
			return 1;
		}
		else if (player->getHP() < 0) {
			tools::out(std::string("AI胜利\n游戏结束"));
			return 1;
		}
		return 0;
	}

	bool chooseRole(const std::string judge_str_player, Role*& judge_Role,int mode) {
		if (judge_str_player[0] == '1') {
			judge_Role = new Double(mode);
			return 1;
		}
		else {
			tools::System("cls");
			tools::out(std::string("输入错误,请重输"));
			return 0;
		}
	}

	void setPlayer(Role*& player) {
		while (1) {
			tools::out(std::string("请输入使用的角色"));
			showRole();
			std::string judge_str_player;
			tools::input(judge_str_player);
			if (chooseRole(judge_str_player, player,1)) {
				break;
			}
		}
	}

	void setAI(Role*& AI) {
		while (1) {
			if (chooseRole(std::to_string(tools::Random(1)), AI,2)) {
				break;
			}
		}
	}
}