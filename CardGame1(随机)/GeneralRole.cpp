#include"GeneralRole.h"

namespace gamerandom {
	int Role::getHP() {
		return basic.HP;
	}

	int Role::getMP() {
		return nowActiveSkill;
	}

	float Role::getAttack() {
		return basic.attack;
	}

	float Role::getDamage() {
		return basic.damage;
	}

	void Role::showBasic() {
		tools::out(std::string("姓名:") + basic.name);//输出性别
		tools::out(std::string("HP:") + std::to_string(basic.HP));
		tools::out(std::string("MP:") + std::to_string(basic.MP));
		tools::out(std::string("总共骰子:") + std::to_string(basic.dicenum));
		tools::out(std::string("攻击骰子:") + std::to_string(basic.ATKnum));
		tools::out(std::string("防御骰子:") + std::to_string(basic.DMGnum));
	}

	void Role::choose() {
		std::string get;
		std::vector<int>attack;
		ATK = 0;
		pushRandom();
		showDCM();
		if (mode == 1) {//mode==1时人来操作
			playear_ATKchoose();
		}
		else if (mode == 2) {//mode==2时AI操作
			AI_ATKchoose();
		}
	}

	void Role::playear_ATKchoose() {
		while (1) {
		Rec://标签，输入错误时跳转到这里
			while (!chooseCard.empty()) {
				chooseCard.erase(chooseCard.begin());
			}
			tools::out(std::string("可选择的数为") + std::to_string(basic.ATKnum));
			for (int i = 0; i < basic.ATKnum; i++) {
			Reic://标签，输入错误时跳转到这里	
				tools::out(std::string("输入第") + std::to_string(i + 1) + std::string("个选择"));
				std::string in;
				tools::input(in);
				if(tools::to_int(in)<0||tools::to_int(in)>basic.dicenum)
					goto Reic;
				chooseCard.insert( tools::to_int(in) - 1);
			}
			//tools::BufferClear();
			if (chooseCard.size() < basic.ATKnum) {
				tools::out(std::string("输入错误，已选择的数为") + std::to_string(chooseCard.size()) + std::string("个，少输入了"));
				goto Rec;
			}
			tools::out(std::string("选择的是"));
			std::string choose = "";
			for (auto i = chooseCard.begin(); i != chooseCard.end(); i++) {
				choose += std::to_string(*i + 1) + " ";
				ATK += DCM[*i];
			}
			tools::out(choose);
			if (tools::judge()) {
				tools::out(std::string("本轮选择总和点数为") + std::to_string(ATK));
				break;
			}
		}
	}

	void Role::AI_ATKchoose() {//AI攻击选择
		std::sort(DCM.begin(), DCM.end(), [](int a, int b) { return a > b; });
		for (int i = 0; i < basic.ATKnum; i++) {
			ATK += DCM[i];
		}
		tools::out(std::string("AI进行攻击，攻击点数为") + std::to_string(ATK));
	}

	void Role::pushRandom() {
		for (int i = 0; i < basic.dicenum; i++) {
			DCM[i] = tools::Random(9) + 1;
		}
	}

	void Role::showDCM() {
		std::string str = std::string("抽取的数值为:\n");
		for (int i = 0; i < basic.dicenum; i++) {
			str += (std::to_string(i + 1)) + " ";
		}
		str += "\n";
		for (int i = 0; i < basic.dicenum; i++) {
			str += std::to_string(DCM[i]) + " ";
		}
		tools::out(str);
	}

	int Role::skill() {
		ATK *= basic.attack;
		if (nowActiveSkill >= basic.activeSkillMP) {
			if (mode == 1) {//主动技能：攻击翻倍
				tools::out(std::string("主动技能已准备好，是否使用主动技能，使用后攻击翻倍"));
				if (Player_SkillChoose()) {
					ATK *= 2;
					nowActiveSkill = 0;
				}
			}
			else if (mode == 2) {//AI主动技能：有概率攻击翻倍
				tools::out(std::string("AI选择发动技能"));
				ATK *= 2;
			}
		}
		if (passiveSkill()) {
			tools::out(std::string("被动技能发动，攻击翻倍\n最终伤害为") + std::to_string(ATK * 4));
			return ATK * 4;
		}
		else {
			tools::out(std::string("被动技能未发动，攻击倍率不变\n最终伤害为") + std::to_string(ATK));
			return ATK;
		}
	}


	bool Role::Player_SkillChoose() {
		tools::out(std::string("输入Y/y使用"));
		if (tools::judge()) {
			tools::out(std::string("主动技能发动，攻击翻倍"));
			return 1;
		}
		else {
			tools::out(std::string("主动技能未发动，攻击倍率不变"));
			return 0;
		}
	}

	void Role::changeHP(int changeHP) {//修改血量
		pushRandom();
		showDCM();
		if(mode == 1) {
			playear_DMGchoose();
		}
		else if (mode == 2) {
			AI_DMGchoose();
		}
		changeHP = std::max(0, (int)((changeHP)*basic.damage - DMG));
		basic.HP -= changeHP;
		tools::out(std::string("本轮防御点数为") + std::to_string(DMG) + std::string("，实际受到的伤害为") + std::to_string(changeHP));
		DMG = 0;
	}

	void Role::playear_DMGchoose() {
		std::set<int> chooseCardDMG;
		while (1) {
		Rec://标签，输入错误时跳转到这里
			while (!chooseCardDMG.empty()) {
				chooseCardDMG.erase(chooseCardDMG.begin());
			}
			tools::out(std::string("可选择的数为") + std::to_string(basic.DMGnum));
			for (int i = 0; i < basic.DMGnum; i++) {
			Reic://标签，输入错误时跳转到这里	
				tools::out(std::string("输入第") + std::to_string(i + 1) + std::string("个选择"));
				std::string in;
				tools::input(in);
				if (tools::to_int(in) < 0 || tools::to_int(in) > basic.dicenum)
					goto Reic;
				chooseCardDMG.insert(tools::to_int(in) - 1);
			}
			if (chooseCardDMG.size() < basic.DMGnum) {
				tools::out(std::string("输入错误，已选择的数为") + std::to_string(chooseCardDMG.size()) + std::string("个，少输入了"));
				goto Rec;
			}
			tools::out(std::string("选择的是"));
			std::string choose = "";
			for (auto i = chooseCardDMG.begin(); i != chooseCardDMG.end(); i++) {
				choose += std::to_string(*i + 1) + " ";
				DMG += DCM[*i];
			}
			tools::out(choose);
			if (tools::judge()) {

				tools::out(std::string("本轮选择总和点数为") + std::to_string(DMG));
				break;
			}
		}
	}

	void Role::AI_DMGchoose() {
		std::sort(DCM.begin(), DCM.end(), [](int a, int b) { return a > b; });
		for (int i = 0; i < basic.DMGnum; i++) {
			DMG += DCM[i];
		}
		tools::out(std::string("AI进行防御，防御点数为") + std::to_string(DMG));
	}

	void Role::changeMP(int MP) {
		nowActiveSkill += MP;
	}
}