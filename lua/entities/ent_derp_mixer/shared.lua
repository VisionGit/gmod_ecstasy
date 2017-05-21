ENT.Type 		= "anim"
ENT.Base 		= "base_gmodentity"
ENT.PrintName 	= "Ecstasy Mixer" 
ENT.Author 		= "Derpes"
ENT.Category 	= "Derpes Drugs"
ENT.Spawnable 	= true

function ENT:SetupDataTables()
	self:NetworkVar("Float",0,"Progress")
	self:NetworkVar("Bool",0,"Cookin")
	self:NetworkVar("Bool",1,"Prepared")
	self:NetworkVar("Bool",2,"HasRatpoison")
	self:NetworkVar("Bool",3,"HasAmphetamine")
end