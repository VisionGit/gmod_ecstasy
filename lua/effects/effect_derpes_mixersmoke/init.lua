function EFFECT:Init(data)

	local vOffset = data:GetOrigin()
	self.Pos=vOffset
	local Emitter=ParticleEmitter(vOffset)

	for i=0,5 do

		local sprite
		local chance=math.random(1,3)

		if(chance==1)then
			sprite="particle/smokestack"
		elseif(chance==2)then
			sprite="particles/smokey"
		elseif(chance==3)then
			sprite="particle/particle_smokegrenade"
		end

		local particle = Emitter:Add(sprite,vOffset)

		if(particle)then
			particle:SetVelocity(math.Rand(0,10)*VectorRand())
			particle:SetAirResistance(20)
			particle:SetDieTime(math.Rand(1,3))
			particle:SetStartAlpha(math.Rand(180,240))
			particle:SetEndAlpha(10)
			local Siz=math.Rand(10,20)
			particle:SetStartSize(Siz/3)
			particle:SetEndSize(Siz)
			particle:SetRoll(math.Rand(-3,3))
			particle:SetRollDelta(math.Rand(-2,2))
			particle:SetGravity(Vector(0,0,math.random(10,20)))
			particle:SetLighting(true)
			particle:SetColor(255,255,255)
			particle:SetCollide(false)
		end

	end

	Emitter:Finish()

end


function EFFECT:Think()
	return false
end


function EFFECT:Render()
	--no
end