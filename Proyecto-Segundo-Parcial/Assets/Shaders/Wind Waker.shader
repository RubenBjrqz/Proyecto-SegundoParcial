Shader "Custom/Shader wind waker" {
	Properties{
		_Color("Color", Color) = (1,1,1,1) 
		_MainTex("Albedo (RGB)", 2D) = "white" {} 
	_CelShadingBlurWidth("Cell Shading Blur Width", Range(0,2)) = 0.2 
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM

#pragma surface surf Toon fullforwardshadows 

#pragma target 3.0

		sampler2D _MainTex;
	sampler2D _RampTex;

	struct Input {
		float2 uv_MainTex;
	};

	half _CelShadingBlurWidth;
	fixed4 _Color;

	void surf(Input IN, inout SurfaceOutput o) {

		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
		o.Albedo = c.rgb;
		o.Alpha = c.a;
	}

	fixed4 LightingToon(SurfaceOutput s, fixed3 lightDir,fixed atten)
	{
		half NdotL = dot(s.Normal, lightDir);  

		half cel;


		if (NdotL < 0.5 - _CelShadingBlurWidth / 2)                                         
			cel = 0;
		else if (NdotL > 0.5 + _CelShadingBlurWidth / 2)                                    
			cel = 1;
		else                                                                                
			cel = 1 - ((0.5 + _CelShadingBlurWidth / 2 - NdotL) / _CelShadingBlurWidth);

		half4 c;

		c.rgb = (cel + 0.3) / 2.5  * s.Albedo * _LightColor0.rgb * atten; 
		c.a = s.Alpha;

		return c;
	}

	ENDCG
	}
		FallBack "Diffuse"
}
