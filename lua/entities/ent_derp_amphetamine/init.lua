AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props_lab/jar01b.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(10)

    self:SetUseType(SIMPLE_USE)
	self:SetColor(Color(255,255,255,255))

end


function ENT:OnTakeDamage(dmg)

    self:TakePhysicsDamage(dmg)

end


function ENT:Use(ply)
    if (ply:KeyDown(IN_WALK)) then
        local steamID = ply:SteamID()
        if CRAFTINGMOD.User[steamID].Inventory:HasInventoryWeight(JackaJobMultipleDrugsCraftingItems.Amphetamine,1,ply) then
            CRAFTINGMOD.User[steamID].Inventory:AddItem(JackaJobMultipleDrugsCraftingItems.Amphetamine,1,ply)
            self:Remove()
        else
            ply:ChatPrint("You need more inventory space to do this.")
        end
    end
end