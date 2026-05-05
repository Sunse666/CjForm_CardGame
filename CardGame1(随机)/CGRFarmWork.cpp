#include "CardGameRandom.h"

namespace gamerandom {
	void SkillMP(std::unique_ptr<Role>& ATK_Role, std::unique_ptr<Role>& DMG_Role,int ChangeMP) {
		ATK_Role->changeMP(ChangeMP);
		DMG_Role->changeMP(ChangeMP);
	}

	void Player_AI(std::unique_ptr<Role>& player, std::unique_ptr<Role>& AI) {
		tools::System("cls");
		tools::out(std::string("玩家回合"));
		player->choose();
		int ATK = player->skill();
		AI->changeHP(ATK);
		SkillMP(player, AI, ATK);
	}

	void AI_Player(std::unique_ptr<Role>& player, std::unique_ptr<Role>& AI) {
		tools::System("cls");
		tools::out(std::string("AI回合"));
		AI->choose();
		int ATK = AI->skill();
		player->changeHP(ATK);
		SkillMP(AI, player, ATK);
	}

	bool GameOver(std::unique_ptr<Role>& player, std::unique_ptr<Role>& AI) {
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

	bool chooseRole(const std::string judge_str_player,std::unique_ptr<Role>& judge_Role,int mode) {
		if (judge_str_player[0] == '1') {
			judge_Role = std::make_unique<Double>(mode);
			return 1;
		}
		else {
			tools::System("cls");
			tools::out(std::string("输入错误,请重输"));
			return 0;
		}
	}

	void setPlayer(std::unique_ptr<Role>& player) {
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

	void setAI(std::unique_ptr<Role>& AI) {
		while (1) {
			if (chooseRole(std::to_string(tools::Random(1)), AI,2)) {
				break;
			}
		}
	}
}