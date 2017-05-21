AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[-------------------------------------------------------------------------
Vision City-Life Ecstasy Config
---------------------------------------------------------------------------]]
local mixingDebug = false--Enable/Disable insta-production
local mixingRate = 0.325--Set the speed of the mixing
local mixingDrop = 4--The amount of produce made
--[[-------------------------------------------------------------------------
End of Ecstasy Config
---------------------------------------------------------------------------]]

local NextThinkHook = 0

function ENT:MakeLiquid(bool)

    if(bool==true)then
        liquidstuff = ents.Create("prop_physics")
        liquidstuff:SetModel("models/props_phx/construct/plastic/plastic_angle_360.mdl")
        liquidstuff:SetModelScale(liquidstuff:GetModelScale()*0.5)
        liquidstuff:SetMaterial("models/shadertest/shader4")
        liquidstuff:SetPos(self:GetPos()+self:GetUp()*15)
        liquidstuff:SetAngles(self:GetAngles())
        liquidstuff:SetParent(self)
        liquidstuff:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        liquidstuff:Spawn()
    elseif(bool==false)then
        --Remove all of the child entities of the mixer
    end

end


function ENT:ResetMixer()

    self:SetProgress(0)
    self:SetCookin(false)
    self:SetPrepared(false)
    self:SetHasRatpoison(false)
    self:SetHasAmphetamine(false)

end


function ENT:Produce(ply)

    if self:GetProgress() >= 100 then

        local Pos,Vel=self:GetPos()+self:GetUp()*58,self:GetVelocity()

        for i=1,mixingDrop do
            local ecstasy=ents.Create("ent_derp_ecstasy")
            ecstasy:SetPos(Pos+VectorRand()*math.random(2,8))
            ecstasy:SetAngles(VectorRand():Angle())
            ecstasy:Spawn()
            ecstasy:Activate()
            ecstasy:GetPhysicsObject():SetVelocity(Vel)
            CRAFTINGMOD.Manager:AddEntityToLimit(ply,"prop",Ecstasy)
            i=i+1
        end

        timer.Simple(.5,function()
            self:ResetMixer()
        end)

    end

end


function ENT:Initialize()

    self:SetModel("models/props_wasteland/laundry_basket001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(10)

    self:SetUseType(SIMPLE_USE)
    self:SetColor(Color(0,150,150,255))

    self:ResetMixer()
    self.Exploded=false

end


function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
    if((self:GetProgress()>0)and not(self.Exploded))then
        self.Exploded=true
        local explode = ents.Create( "env_explosion" )
        explode:SetPos( self:GetPos() )
        explode:Spawn()
        explode:SetKeyValue( "iMagnitude", "100" )
        explode:Fire( "Explode", 0, 0 )
        for i=1,10 do
            local Tr=util.QuickTrace(self:GetPos(),VectorRand()*100)
            if(Tr.Hit)then
                local fire = ents.Create("env_fire")
                fire:SetPos(Tr.HitPos)
                fire:SetKeyValue("spawnflags", tostring(128 + 4))
                fire:SetKeyValue("firesize", (20 * math.Rand(0.7, 1.1)))
                fire:SetKeyValue("fireattack", "20")
                fire:SetKeyValue("health", "30")
                fire:SetKeyValue("damagescale", "10")
                fire:Spawn()
                fire:Activate()
            end
        end
        self:Remove()
    end
end


function ENT:Think()
    local Time,ThinkRate=CurTime(),1
    if(self:GetCookin())then
        self:SetProgress(self:GetProgress()+(mixingRate/2))
        if(self:GetProgress()>=100)then
            self:SetProgress(100)
        end
        EffectData():SetOrigin( self:GetPos()+self:GetUp()*12 )
        util.Effect( "effect_derpes_mixersmoke", EffectData(), true, true )
    end
    self:NextThink(Time+ThinkRate)
    return true
end


function ENT:Use(ply)

    if (ply:KeyDown(IN_WALK)) then
        local steamID = ply:SteamID()
        if (self:GetProgress() >= 100) or (not self:GetPrepared()) then
            if CRAFTINGMOD.User[steamID].Inventory:HasInventoryWeight(JackaJobMultipleDrugsCraftingItems.MixingPot,1,ply) then
                CRAFTINGMOD.User[steamID].Inventory:AddItem(JackaJobMultipleDrugsCraftingItems.MixingPot,1,ply)
                self:Remove()
            else
                ply:ChatPrint("You need more inventory space to do this.")
            end
        else
            ply:ChatPrint("You cannot pickup an incomplete mixer.")
        end
    end

    if self:GetPrepared() == false then return end

    if self:GetCookin() then
        self:SetCookin(false)
        self:EmitSound( "HL1/fvox/beep.wav", 75, 100, 1, CHAN_AUTO )
    else
        if self:GetProgress() >= 100 then
            self:Produce(ply)
            return
        end
        self:SetCookin(true)
        self:EmitSound( "HL1/fvox/bell.wav", 75, 100, 1, CHAN_AUTO )
    end

end


function ENT:Touch(touched)

    if touched:GetClass() == "ent_derp_ratpoison" then
        touched:Remove()
        self:SetHasRatpoison(true)
    end

    if touched:GetClass() == "ent_derp_amphetamine" then
        touched:Remove()
        self:SetHasAmphetamine(true)
    end

    if self:GetHasAmphetamine() and self:GetHasRatpoison() and not self:GetPrepared() then
        self:SetPrepared(true)
        self:MakeLiquid(true)
    end

end


--Stop default gmod pickup messing with the mixer
hook.Add( "AllowPlayerPickup", "ecstasyStopPickup", function(ply,ent)
    if(ent:GetClass()=="ent_derp_mixer")then return false end
    if(ent:GetModel()=="models/props_phx/construct/plastic/plastic_angle_360.mdl")then return false end
end)