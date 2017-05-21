include("shared.lua")

function ENT:ResourceColor(type)
	if type == 1 then
		if(self:GetHasRatpoison())then
			return Color(0,150,150,200)
		else
			return Color(200,20,20,200)
		end
	elseif type == 2 then
		if(self:GetHasAmphetamine())then
			return Color(0,150,150,200)
		else
			return Color(200,20,20,200)
		end
	end
end


function ENT:Draw()
	
    self:DrawModel()

	local Ang,Pos=self:GetAngles(),self:GetPos()

	if(self:GetCookin())then

		local SelfPos,Right,Up,Forward,Ang,White=self:GetPos(),self:GetRight(),self:GetUp(),self:GetForward(),self:GetAngles(),Color(0,150,150,200)
		Ang:RotateAroundAxis(Ang:Forward(),90)
		Ang:RotateAroundAxis(Ang:Right(),-90)
        cam.Start3D2D(SelfPos+Forward*26+Up*11+Right*10,Ang,.1)
        draw.RoundedBox(5,0,0,200,120,Color(30,30,30,220))
			local Col=Color(0,150,150,200)
			if not(self:GetProgress()>=100)then
				draw.SimpleTextOutlined("Mixing","DermaLarge",100,20,Col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,220))
			else
				draw.SimpleTextOutlined("Complete","DermaLarge",100,20,Col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,220))
			end
			draw.SimpleTextOutlined(tostring( math.Round( math.Clamp( self:GetProgress(),0,100 ) ) ).."%","DermaLarge",103,60,Col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,220))
        cam.End3D2D()

    elseif(self:GetCookin()==false)and(self:GetPrepared()==false)then

    	local SelfPos,Right,Up,Forward,Ang,White=self:GetPos(),self:GetRight(),self:GetUp(),self:GetForward(),self:GetAngles(),Color(0,150,150,200)
		Ang:RotateAroundAxis(Ang:Forward(),90)
		Ang:RotateAroundAxis(Ang:Right(),-90)
        cam.Start3D2D(SelfPos+Forward*26+Up*11+Right*10,Ang,.1)
        draw.RoundedBox(5,-20,0,240,120,Color(30,30,30,220))
			local Col=Color(0,150,150,200)
			if(self:GetHasAmphetamine()) then ColAmphetamine=Color(0,150,150,200) else ColAmphetamine=Color(200,20,20,200) end
			draw.SimpleTextOutlined("Items Required","DermaLarge",100,20,Col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,220))
			draw.SimpleTextOutlined("Rat Poison","Trebuchet20",103,50,self:ResourceColor(1),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,220))
			draw.SimpleTextOutlined("Amphetamine","Trebuchet20",103,75,self:ResourceColor(2),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,220))
        cam.End3D2D()

    elseif(self:GetCookin()==false)and(self:GetPrepared())then

    	local SelfPos,Right,Up,Forward,Ang,White=self:GetPos(),self:GetRight(),self:GetUp(),self:GetForward(),self:GetAngles(),Color(0,150,150,200)
		Ang:RotateAroundAxis(Ang:Forward(),90)
		Ang:RotateAroundAxis(Ang:Right(),-90)
        cam.Start3D2D(SelfPos+Forward*26+Up*11+Right*10,Ang,.1)
        draw.RoundedBox(5,0,0,200,120,Color(30,30,30,220))
			local Col=Color(0,150,150,200)
			draw.SimpleTextOutlined("Mixing Paused","DermaLarge",100,20,Col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,220))
			draw.SimpleTextOutlined("Toggle with E","DermaLarge",103,60,Col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,220))
        cam.End3D2D()

    end

end
