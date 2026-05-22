package myapp

import std.collection.*
import cjform.*

public class Rng {
    private var counter: Int64

    public init() {
        counter = Int64(0)
    }

    public func nextInt(max: Int32): Int32 {
        counter = counter + Int64(1)
        let tick = ffi_getTickCount()
        let combined = tick + counter
        let r = combined % Int64(max)
        if (r < Int64(0)) {
            Int32(r + Int64(max) + Int64(1))
        } else {
            Int32(r + Int64(1))
        }
    }

    public func nextFloat(): Float32 {
        Float32(nextInt(1000)) / Float32(1000)
    }
}

public struct CharData {
    public let id: Int32
    public let name: String
    public let desc: String
    public let maxHP: Int32
    public let activeSkillCost: Int32
    public let passiveSkillThreshold: Int32
    public let physicalAttackMul: Float32
    public let magicalAttackMul: Float32
    public let physicalDefense: Float32
    public let magicalDefense: Float32
    public let dicenum: Int32
    public let ATKnum: Int32
    public let DMGnum: Int32

    public init(id: Int32, name: String, desc: String, maxHP: Int32,
                activeSkillCost: Int32, passiveSkillThreshold: Int32,
                physicalAttackMul: Float32, magicalAttackMul: Float32,
                physicalDefense: Float32, magicalDefense: Float32,
                dicenum: Int32, ATKnum: Int32, DMGnum: Int32) {
        this.id = id
        this.name = name
        this.desc = desc
        this.maxHP = maxHP
        this.activeSkillCost = activeSkillCost
        this.passiveSkillThreshold = passiveSkillThreshold
        this.physicalAttackMul = physicalAttackMul
        this.magicalAttackMul = magicalAttackMul
        this.physicalDefense = physicalDefense
        this.magicalDefense = magicalDefense
        this.dicenum = dicenum
        this.ATKnum = ATKnum
        this.DMGnum = DMGnum
    }
}

public func getAllClasses(): ArrayList<CharData> {
    let list = ArrayList<CharData>()
    list.add(CharData(1, "剑士", "均衡物理型 — 物法兼备",
        80, 100, 4, 0.60, 0.20, 0.15, 0.10, 5, 4, 3))
    list.add(CharData(2, "盾卫", "坦克型 — 高血量高双防",
        130, 130, 3, 0.35, 0.10, 0.30, 0.25, 4, 3, 3))
    list.add(CharData(3, "暗影", "刺客型 — 极限物攻低防",
        55, 75, 6, 0.85, 0.15, 0.05, 0.05, 5, 4, 2))
    list.add(CharData(4, "术士", "技能型 — 法术为主",
        65, 60, 3, 0.15, 0.80, 0.10, 0.15, 6, 5, 2))
    list.add(CharData(5, "狂战", "狂战型 — 极限物攻输出",
        70, 85, 7, 0.75, 0.30, 0.05, 0.05, 5, 5, 2))
    list.add(CharData(6, "圣骑", "均衡双修型 — 双攻双防",
        100, 110, 5, 0.45, 0.40, 0.20, 0.20, 4, 3, 3))
    list.add(CharData(7, "元素使", "纯法型 — 极限法攻",
        55, 55, 4, 0.10, 0.90, 0.05, 0.20, 6, 5, 2))
    list.add(CharData(8, "死灵", "法坦型 — 法攻为主偏防御",
        60, 65, 5, 0.20, 0.70, 0.10, 0.15, 5, 4, 3))
    list
}

public class Character {
    public let data: CharData
    public var hp: Int32
    public var skillPoints: Int32
    public var shields: Int32
    public var diceResults: ArrayList<Int32>
    public var physDice: ArrayList<Bool>
    public var magDice: ArrayList<Bool>

    public init(data: CharData) {
        this.data = data
        this.hp = data.maxHP
        this.skillPoints = 0
        this.shields = 3
        this.diceResults = ArrayList<Int32>()
        this.physDice = ArrayList<Bool>()
        this.magDice = ArrayList<Bool>()
        let totalDice = data.dicenum
        for (_ in 0..totalDice) {
            diceResults.add(0)
            physDice.add(false)
            magDice.add(false)
        }
    }

    public func getDice(index: Int32): Int32 {
        var result: Int32 = 0
        var pos: Int32 = 0
        for (v in diceResults) {
            if (pos == index) { result = v }
            pos = pos + 1
        }
        result
    }

    public func isPhysDice(index: Int32): Bool {
        var result: Bool = false
        var pos: Int32 = 0
        for (s in physDice) {
            if (pos == index) { result = s }
            pos = pos + 1
        }
        result
    }

    public func isMagDice(index: Int32): Bool {
        var result: Bool = false
        var pos: Int32 = 0
        for (s in magDice) {
            if (pos == index) { result = s }
            pos = pos + 1
        }
        result
    }

    public func cycleDiceMode(index: Int32): Unit {
        let isPhys = isPhysDice(index)
        let isMag = isMagDice(index)
        let newPhys = ArrayList<Bool>()
        let newMag = ArrayList<Bool>()
        var pos: Int32 = 0
        let totalDice = data.dicenum
        for (_ in 0..totalDice) {
            if (pos == index) {
                if (!isPhys && !isMag) {
                    newPhys.add(true)
                    newMag.add(false)
                } else if (isPhys) {
                    newPhys.add(false)
                    newMag.add(true)
                } else {
                    newPhys.add(false)
                    newMag.add(false)
                }
            } else {
                newPhys.add(isPhysDice(pos))
                newMag.add(isMagDice(pos))
            }
            pos = pos + 1
        }
        physDice = newPhys
        magDice = newMag
    }

    public func rollDice(rng: Rng): Unit {
        let totalDice = data.dicenum
        let newDice = ArrayList<Int32>()
        let newPhys = ArrayList<Bool>()
        let newMag = ArrayList<Bool>()
        for (_ in 0..totalDice) {
            newDice.add(rng.nextInt(9))
            newPhys.add(false)
            newMag.add(false)
        }
        diceResults = newDice
        physDice = newPhys
        magDice = newMag
    }

    public func clearSelection(): Unit {
        let totalDice = data.dicenum
        let newPhys = ArrayList<Bool>()
        let newMag = ArrayList<Bool>()
        for (_ in 0..totalDice) {
            newPhys.add(false)
            newMag.add(false)
        }
        physDice = newPhys
        magDice = newMag
    }

    public func getPhysSum(): Int32 {
        var sum: Int32 = 0
        var pos: Int32 = 0
        for (_ in physDice) {
            if (isPhysDice(pos)) { sum = sum + getDice(pos) }
            pos = pos + 1
        }
        sum
    }

    public func getMagSum(): Int32 {
        var sum: Int32 = 0
        var pos: Int32 = 0
        for (_ in magDice) {
            if (isMagDice(pos)) { sum = sum + getDice(pos) }
            pos = pos + 1
        }
        sum
    }

    public func getPhysCount(): Int32 {
        var count: Int32 = 0
        var pos: Int32 = 0
        for (_ in physDice) {
            if (isPhysDice(pos)) { count = count + 1 }
            pos = pos + 1
        }
        count
    }

    public func getMagCount(): Int32 {
        var count: Int32 = 0
        var pos: Int32 = 0
        for (_ in magDice) {
            if (isMagDice(pos)) { count = count + 1 }
            pos = pos + 1
        }
        count
    }

    public func getTotalCount(): Int32 {
        getPhysCount() + getMagCount()
    }

    public func aiSelect(totalCount: Int32, physRatio: Float32): Unit {
        let totalDice = data.dicenum
        let topIndices = ArrayList<Int32>()
        var used = ArrayList<Bool>()
        for (_ in 0..totalDice) { used.add(false) }

        for (_ in 0..totalCount) {
            var bestIdx: Int32 = -1
            var bestVal: Int32 = -1
            var pi: Int32 = 0
            for (u in used) {
                if (!u) {
                    let val = getDice(pi)
                    if (val > bestVal) {
                        bestVal = val
                        bestIdx = pi
                    }
                }
                pi = pi + 1
            }
            if (bestIdx >= 0) {
                let newUsed = ArrayList<Bool>()
                var pj: Int32 = 0
                for (uv in used) {
                    if (pj == bestIdx) { newUsed.add(true) }
                    else { newUsed.add(uv) }
                    pj = pj + 1
                }
                used = newUsed
                topIndices.add(bestIdx)
            }
        }

        var physCount = Int32(Float32(totalCount) * physRatio)
        if (physCount < 0) { physCount = 0 }
        if (physCount > totalCount) { physCount = totalCount }

        let newPhys = ArrayList<Bool>()
        let newMag = ArrayList<Bool>()
        var pi2: Int32 = 0
        for (_ in 0..totalDice) {
            var assignedPhys: Bool = false
            var assignedMag: Bool = false
            var rank: Int32 = 0
            for (ti in topIndices) {
                if (ti == pi2) {
                    if (rank < physCount) { assignedPhys = true }
                    else { assignedMag = true }
                }
                rank = rank + 1
            }
            newPhys.add(assignedPhys)
            newMag.add(assignedMag)
            pi2 = pi2 + 1
        }
        physDice = newPhys
        magDice = newMag
    }

    public func checkShield(rawAttack: Int32, rng: Rng): Bool {
        if (shields <= 0) { return false }
        let threshold: Int32 = data.maxHP * 3 / 10
        if (rawAttack < threshold) { return false }

        let hpRatio = Float32(hp) / Float32(data.maxHP)
        let prob = (Float32(1) - hpRatio) * Float32(0.85)
        let roll = rng.nextFloat()

        if (roll < prob) {
            shields = shields - 1
            return true
        }
        false
    }

    public func canUseSkill(): Bool {
        skillPoints >= data.activeSkillCost
    }

    public func useSkill(): Unit {
        skillPoints = 0
    }

    public func checkPassiveSkill(rng: Rng): Bool {
        rng.nextInt(10) > data.passiveSkillThreshold
    }

    public func addSkillPoints(amount: Int32): Unit {
        skillPoints = skillPoints + amount
    }
}

public enum GamePhase {
    | SELECT_CHARACTER
    | PLAYER_ROLL
    | PLAYER_ATTACK
    | AI_TURN
    | PLAYER_DEFEND
    | ROUND_RESULT
    | GAME_OVER
}

public class CardGameEngine {
    public var player: Character
    public var ai: Character
    public var phase: GamePhase
    public var rng: Rng
    public var messages: ArrayList<String>
    public var lastAIPhysAtk: Int32
    public var lastAIMagAtk: Int32
    public var playerSkillToggled: Bool
    public var aiDebuff: Float32
    public var playerVuln: Float32
    public var playerCounter: Float32

    public init() {
        player = Character(getAllClasses()[0])
        ai = Character(getAllClasses()[0])
        phase = GamePhase.SELECT_CHARACTER
        rng = Rng()
        messages = ArrayList<String>()
        lastAIPhysAtk = 0
        lastAIMagAtk = 0
        playerSkillToggled = false
        aiDebuff = Float32(1)
        playerVuln = Float32(1)
        playerCounter = Float32(0)
    }

    public func selectPlayerClass(charData: CharData): Unit {
        player = Character(charData)
        log("你选择了: ${charData.name} — ${charData.desc}")
        let allClasses = getAllClasses()
        let aiIdx = rng.nextInt(Int32(allClasses.size))
        let idx = aiIdx - 1
        ai = Character(allClasses[Int64(idx)])
        log("AI选择了: ${ai.data.name} — ${ai.data.desc}")
        phase = GamePhase.PLAYER_ROLL
    }

    public func log(msg: String): Unit {
        messages.add(msg)
        if (messages.size > 20) {
            let newMsgs = ArrayList<String>()
            var pos: Int32 = 0
            let total: Int32 = Int32(messages.size)
            for (m in messages) {
                if (pos >= total - 20) { newMsgs.add(m) }
                pos = pos + 1
            }
            messages = newMsgs
        }
    }

    public func getRecentMessages(): String {
        var result: String = ""
        let total: Int32 = Int32(messages.size)
        let start: Int32 = if (total > 8) { total - 8 } else { 0 }
        var pos: Int32 = 0
        for (m in messages) {
            if (pos >= start) { result = result + m + "\n" }
            pos = pos + 1
        }
        result
    }

    public func playerRoll(): Unit {
        player.rollDice(rng)
        log("玩家掷出骰子: " + diceToString(player))
        phase = GamePhase.PLAYER_ATTACK
    }

    public func toggleSkill(): Unit {
        playerSkillToggled = !playerSkillToggled
    }

    public func canActivateSkill(): Bool {
        player.canUseSkill()
    }

    public func playerAttack(): Int32 {
        let physSum = player.getPhysSum()
        let magSum = player.getMagSum()
        var physAtk = Int32(Float32(physSum) * player.data.physicalAttackMul)
        var magAtk = Int32(Float32(magSum) * player.data.magicalAttackMul)
        log("玩家物攻: ${physAtk} (骰${physSum}x${player.data.physicalAttackMul}), 法攻: ${magAtk} (骰${magSum}x${player.data.magicalAttackMul})")

        var skillPhysPen: Float32 = Float32(0)
        var skillMagPen: Float32 = Float32(0)
        var skillIgnoreDice: Bool = false
        var skillLifesteal: Float32 = Float32(0)
        var skillHealPct: Float32 = Float32(0)

        if (playerSkillToggled && player.canUseSkill()) {
            player.useSkill()
            let id = player.data.id
            match (id) {
                case 1 => // 剑士 - 剑气斩
                    physAtk = Int32(Float32(physAtk) * Float32(1.5))
                    magAtk = Int32(Float32(magAtk) * Float32(1.5))
                    log("⚔ 剑气斩! 物攻法攻 +50%")
                case 2 => // 盾卫 - 坚盾
                    playerVuln = Float32(0.6)
                    playerCounter = Float32(0.2)
                    log("🛡 坚盾! 受到伤害-40%, 反弹20%伤害")
                case 3 => // 暗影 - 暗杀
                    physAtk = Int32(Float32(physAtk) * Float32(1.3))
                    magAtk = Int32(Float32(magAtk) * Float32(1.3))
                    log("🗡 暗杀! 攻击+30%, 暴击率大幅提升")
                case 4 => // 术士 - 奥术爆发
                    magAtk = Int32(Float32(magAtk) * Float32(1.6))
                    skillMagPen = Float32(0.3)
                    log("🔮 奥术爆发! 法攻+60%, 穿透30%法防")
                case 5 => // 狂战 - 狂暴
                    physAtk = Int32(Float32(physAtk) * Float32(1.7))
                    magAtk = Int32(Float32(magAtk) * Float32(1.7))
                    playerVuln = Float32(1.3)
                    log("💢 狂暴! 攻击+70%, 但受到伤害+30%")
                case 6 => // 圣骑 - 圣光审判
                    physAtk = Int32(Float32(physAtk) * Float32(1.25))
                    magAtk = Int32(Float32(magAtk) * Float32(1.25))
                    skillHealPct = Float32(0.2)
                    log("✨ 圣光审判! 攻击+25%, 回复20%HP")
                case 7 => // 元素使 - 元素过载
                    magAtk = Int32(Float32(magAtk) * Float32(2.0))
                    skillIgnoreDice = true
                    log("⚡ 元素过载! 法攻翻倍, 无视防御骰")
                case 8 => // 死灵 - 灵魂收割
                    physAtk = Int32(Float32(physAtk) * Float32(1.2))
                    magAtk = Int32(Float32(magAtk) * Float32(1.2))
                    skillLifesteal = Float32(0.4)
                    aiDebuff = Float32(0.75)
                    log("💀 灵魂收割! 攻击+20%, 吸血40%, 削弱敌方下回合攻击")
                case _ => ()
            }
            playerSkillToggled = false
        }

        // Passive crit (暗影 skill boosts this via the threshold mechanism)
        if (player.checkPassiveSkill(rng)) {
            let critMult = if (player.data.id == 3 && player.skillPoints == 0) { Float32(4) } else { Float32(4) }
            physAtk = Int32(Float32(physAtk) * critMult)
            magAtk = Int32(Float32(magAtk) * critMult)
            log("被动技能暴击! x${critMult} -> 物攻:${physAtk} 法攻:${magAtk}")
        }

        let totalRaw = physAtk + magAtk
        if (ai.checkShield(totalRaw, rng)) {
            log("AI护盾触发! 伤害被完全抵消 (剩余护盾: ${ai.shields})")
            player.addSkillPoints(totalRaw * 2)
            ai.addSkillPoints(totalRaw)
            playerVuln = Float32(1)
            playerCounter = Float32(0)
            phase = GamePhase.AI_TURN
            return 0
        }

        // AI defends
        ai.rollDice(rng)
        let aiDefPhysRatio = (Float32(1) - ai.data.physicalDefense) / ((Float32(1) - ai.data.physicalDefense) + (Float32(1) - ai.data.magicalDefense))
        ai.aiSelect(ai.data.DMGnum, aiDefPhysRatio)
        var physDef = ai.getPhysSum()
        var magDef = ai.getMagSum()

        // Apply penetration / ignore dice
        if (skillIgnoreDice) {
            physDef = 0
            magDef = 0
            log("元素过载: 无视AI防御骰!")
        } else {
            physDef = Int32(Float32(physDef) * (Float32(1) - skillPhysPen))
            magDef = Int32(Float32(magDef) * (Float32(1) - skillMagPen))
        }
        log("AI物防骰: ${physDef}(${ai.getPhysCount()}个), 法防骰: ${magDef}(${ai.getMagCount()}个)")

        let physDmg = Int32(Float32(max2(0, physAtk - physDef)) * (Float32(1) - ai.data.physicalDefense))
        let magDmg = Int32(Float32(max2(0, magAtk - magDef)) * (Float32(1) - ai.data.magicalDefense))
        var totalDmg = physDmg + magDmg

        // Lifesteal
        if (skillLifesteal > Float32(0)) {
            let heal = Int32(Float32(totalDmg) * skillLifesteal)
            player.hp = min2(player.data.maxHP, player.hp + heal)
            log("灵魂收割: 吸血回复 ${heal} HP")
        }

        // Heal
        if (skillHealPct > Float32(0)) {
            let heal = Int32(Float32(player.data.maxHP) * skillHealPct)
            player.hp = min2(player.data.maxHP, player.hp + heal)
            log("圣光审判: 回复 ${heal} HP")
        }

        ai.hp = max2(0, ai.hp - totalDmg)
        log("AI受到 物伤:${physDmg} + 法伤:${magDmg} = ${totalDmg} 伤害, 剩余HP: ${ai.hp}/${ai.data.maxHP}")

        player.addSkillPoints(totalRaw * 2)
        ai.addSkillPoints(totalRaw)

        phase = GamePhase.AI_TURN
        totalDmg
    }

    public func aiAttack(): Int32 {
        ai.rollDice(rng)
        let aiAtkPhysRatio = ai.data.physicalAttackMul / (ai.data.physicalAttackMul + ai.data.magicalAttackMul)
        ai.aiSelect(ai.data.ATKnum, aiAtkPhysRatio)
        let physSum = ai.getPhysSum()
        let magSum = ai.getMagSum()
        var physAtk = Int32(Float32(physSum) * ai.data.physicalAttackMul)
        var magAtk = Int32(Float32(magSum) * ai.data.magicalAttackMul)
        log("AI物攻: ${physAtk} (骰${physSum}x${ai.data.physicalAttackMul}), 法攻: ${magAtk} (骰${magSum}x${ai.data.magicalAttackMul})")

        // AI auto-uses skill
        var aiSkillPhysPen: Float32 = Float32(0)
        var aiSkillMagPen: Float32 = Float32(0)
        var aiSkillIgnoreDice: Bool = false

        if (ai.canUseSkill()) {
            ai.useSkill()
            let aiId = ai.data.id
            match (aiId) {
                case 1 =>
                    physAtk = Int32(Float32(physAtk) * Float32(1.5))
                    magAtk = Int32(Float32(magAtk) * Float32(1.5))
                    log("AI ⚔ 剑气斩! 物攻法攻 +50%")
                case 2 =>
                    log("AI 🛡 坚盾! 受到伤害-40%, 反弹20%")
                case 3 =>
                    physAtk = Int32(Float32(physAtk) * Float32(1.3))
                    magAtk = Int32(Float32(magAtk) * Float32(1.3))
                    log("AI 🗡 暗杀! 攻击+30%")
                case 4 =>
                    magAtk = Int32(Float32(magAtk) * Float32(1.6))
                    aiSkillMagPen = Float32(0.3)
                    log("AI 🔮 奥术爆发! 法攻+60%, 穿透30%法防")
                case 5 =>
                    physAtk = Int32(Float32(physAtk) * Float32(1.7))
                    magAtk = Int32(Float32(magAtk) * Float32(1.7))
                    log("AI 💢 狂暴! 攻击+70%, 受到伤害+30%")
                case 6 =>
                    physAtk = Int32(Float32(physAtk) * Float32(1.25))
                    magAtk = Int32(Float32(magAtk) * Float32(1.25))
                    let heal = Int32(Float32(ai.data.maxHP) * Float32(0.2))
                    ai.hp = min2(ai.data.maxHP, ai.hp + heal)
                    log("AI ✨ 圣光审判! 攻击+25%, 回复 ${heal} HP")
                case 7 =>
                    magAtk = Int32(Float32(magAtk) * Float32(2.0))
                    aiSkillIgnoreDice = true
                    log("AI ⚡ 元素过载! 法攻翻倍, 无视防御骰")
                case 8 =>
                    physAtk = Int32(Float32(physAtk) * Float32(1.2))
                    magAtk = Int32(Float32(magAtk) * Float32(1.2))
                    log("AI 💀 灵魂收割! 攻击+20%, 吸血40%")
                case _ => ()
            }
        }

        if (ai.checkPassiveSkill(rng)) {
            physAtk = Int32(Float32(physAtk) * Float32(4))
            magAtk = Int32(Float32(magAtk) * Float32(4))
            log("AI被动技能暴击!")
        }

        // Apply debuff from player's skill
        physAtk = Int32(Float32(physAtk) * aiDebuff)
        magAtk = Int32(Float32(magAtk) * aiDebuff)
        if (aiDebuff < Float32(1)) {
            log("灵魂收割削弱: AI攻击降低 ${Int32((Float32(1) - aiDebuff) * Float32(100))}%")
            aiDebuff = Float32(1)
        }

        let totalRaw = physAtk + magAtk
        if (player.checkShield(totalRaw, rng)) {
            log("你的护盾触发! 伤害被完全抵消 (剩余护盾: ${player.shields})")
            player.addSkillPoints(totalRaw)
            ai.addSkillPoints(totalRaw * 2)
            lastAIPhysAtk = 0
            lastAIMagAtk = 0
            playerVuln = Float32(1)
            playerCounter = Float32(0)
            phase = GamePhase.ROUND_RESULT
            return 0
        }

        player.rollDice(rng)
        lastAIPhysAtk = physAtk
        lastAIMagAtk = magAtk
        // Store AI penetration for defense calculation
        log("AI发动攻击! 物攻:${physAtk} 法攻:${magAtk} | 请选 ${player.data.DMGnum} 个防御骰子")

        phase = GamePhase.PLAYER_DEFEND
        physAtk + magAtk
    }

    public func playerDefend(): Int32 {
        let physDef = player.getPhysSum()
        let magDef = player.getMagSum()
        log("玩家物防骰: ${physDef}(${player.getPhysCount()}个), 法防骰: ${magDef}(${player.getMagCount()}个)")

        var physDmg = Int32(Float32(max2(0, lastAIPhysAtk - physDef)) * (Float32(1) - player.data.physicalDefense))
        var magDmg = Int32(Float32(max2(0, lastAIMagAtk - magDef)) * (Float32(1) - player.data.magicalDefense))

        // Apply vuln from player's own skill (狂战, 盾卫)
        if (playerVuln != Float32(1)) {
            physDmg = Int32(Float32(physDmg) * playerVuln)
            magDmg = Int32(Float32(magDmg) * playerVuln)
            if (playerVuln < Float32(1)) {
                log("坚盾减伤生效! 伤害 -${Int32((Float32(1) - playerVuln) * Float32(100))}%")
            } else {
                log("狂暴负面: 受到伤害 +${Int32((playerVuln - Float32(1)) * Float32(100))}%")
            }
            playerVuln = Float32(1)
        }

        var totalDmg = physDmg + magDmg

        // Counter damage (盾卫)
        if (playerCounter > Float32(0)) {
            let counterDmg = Int32(Float32(totalDmg) * playerCounter)
            ai.hp = max2(0, ai.hp - counterDmg)
            log("坚盾反击! AI受到 ${counterDmg} 反弹伤害")
            playerCounter = Float32(0)
        }

        player.hp = max2(0, player.hp - totalDmg)
        log("你受到 物伤:${physDmg} + 法伤:${magDmg} = ${totalDmg} 伤害, 剩余HP: ${player.hp}/${player.data.maxHP}")

        player.addSkillPoints(lastAIPhysAtk + lastAIMagAtk)
        ai.addSkillPoints((lastAIPhysAtk + lastAIMagAtk) * 2)

        phase = GamePhase.ROUND_RESULT
        totalDmg
    }

    public func startNewRound(): Unit {
        if (isGameOver()) {
            phase = GamePhase.GAME_OVER
        } else {
            phase = GamePhase.PLAYER_ROLL
        }
    }

    public func isGameOver(): Bool {
        player.hp <= 0 || ai.hp <= 0
    }

    public func getWinner(): String {
        if (ai.hp <= 0) { "玩家胜利!" }
        else if (player.hp <= 0) { "AI胜利!" }
        else { "" }
    }

    private func diceToString(ch: Character): String {
        var s: String = ""
        var pos: Int32 = 0
        let totalDice = ch.data.dicenum
        for (_ in 0..totalDice) {
            s = s + "${ch.getDice(pos)} "
            pos = pos + 1
        }
        s
    }
}

public func max2(a: Int32, b: Int32): Int32 {
    if (a > b) { a } else { b }
}

public func min2(a: Int32, b: Int32): Int32 {
    if (a < b) { a } else { b }
}
