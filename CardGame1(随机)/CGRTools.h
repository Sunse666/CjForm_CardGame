#ifndef GAMERANDOMCOMMON_H
#define GAMERANDOMCOMMON_H

#include "Tools.h"
#include "GeneralRole.h"

namespace gamerandom {
	RoleType Load_GameRandomRole(std::string& address_);//从文件加载角色数据

	void showRole();
}

#endif // RANDOMCOMMON_H