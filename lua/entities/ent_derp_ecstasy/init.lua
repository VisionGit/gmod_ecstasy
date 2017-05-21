AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("DerpesHighOnEcstasy")

local IsSpangled

function ENT:Initialize()
    self:SetModel("models/props_lab/jar01b.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(10)
    self:SetUseType(SIMPLE_USE)
	self:SetColor(Color(50,100,200,255))
end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
end

function ENT:Think()
    
end

function ENT:Use(ply)
    if (ply:KeyDown(IN_WALK)) then
        local steamID = ply:SteamID()
        if CRAFTINGMOD.User[steamID].Inventory:HasInventoryWeight(JackaJobMultipleDrugsCraftingItems.Ecstasy,1,ply) then
            CRAFTINGMOD.User[steamID].Inventory:AddItem(JackaJobMultipleDrugsCraftingItems.Ecstasy,1,ply)
        else
            ply:ChatPrint("You need more inventory space to do this.")
        end
    else
        if IsValid(ply) then
            if ply.IsSpangled then
                ply:PickupObject(self)
            else 
                local OrigFOV = ply:GetFOV()
                ply:SetFOV(99,1)
                ply.IsSpangled = true

                net.Start("DerpesHighOnEcstasy")
                net.WriteBool(ply.IsSpangled)
                net.Send(ply)

                ply:EmitSound("ambient/voices/m_scream1.wav")
                timer.Simple(8,function() ply:EmitSound("vo/npc/male01/moan0"..math.random(1,4)..".wav") end)
                timer.Simple(16,function() ply:EmitSound("ambient/voices/m_scream1.wav") end)

                timer.Simple(40,function()
                    ply:SetFOV(OrigFOV,1)
                    ply.IsSpangled = false
                    net.Start("DerpesHighOnEcstasy")
                    net.WriteBool(ply.IsSpangled)
                    net.Send(ply)
                end)

                self:Remove()
            end
        end
    end
end

function ENT:OnRemove()
    
end