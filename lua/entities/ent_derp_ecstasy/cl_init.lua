include("shared.lua")

function ENT:Initialize()
	
end

function ENT:Draw()

    self:DrawModel()

end

function ENT:Think()
    
end

net.Receive("DerpesHighOnEcstasy",function()
    LocalPlayer().IsSpangled = net.ReadBool()
end)

hook.Add("RenderScreenspaceEffects","DerpesEcstasyVisuals",function()
    if((LocalPlayer().IsSpangled)and(LocalPlayer():Alive()))then
        DrawSharpen(1,1.5)
        DrawBloom( 0.65, 2, 9, 9, 1, 1, 1, 1, 1 )
        DrawSobel( 0.9 )
    end
end)