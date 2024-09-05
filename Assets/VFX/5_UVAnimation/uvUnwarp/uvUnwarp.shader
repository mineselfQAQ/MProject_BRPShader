Shader "MineselfShader/VFX/5-UVAnimation/uvUnwarp"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Control("Control---0:Common 1:uv", Range(0, 1)) = 0
        [Space(5)]
        _uvX("UV:X", Range(0, 5)) = 1
        _uvY("UV:Y", Range(0, 5)) = 1
        [Space(5)]
        _FresnelPow("FresnelPower", Range(0, 10)) = 3
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _MainTex;
            float _Control;
            float _uvX;
            float _uvY;
            float _FresnelPow;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;

                //展开的核心---普通pos与uvPos的切换
                //普通pos其实就是v.vertex
                //uvPos是将uv传入，作为图形显示，那么正常来说会像是一个Quad
                //由于uv是[0,1]，我们需要将其放在[-0.5,0.5]上，然后进行缩放操作
                v.uv2 -= 0.5;
                v.uv2 = float2(v.uv2.x * _uvX, v.uv2.y * _uvY);
                float4 uvPos = float4(v.uv2, 0, 0);
                float4 pos = lerp(v.vertex, uvPos, _Control);

                o.pos = UnityObjectToClipPos(pos);

                o.uv = v.uv;
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                //计算光照向量
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //计算光照
                float3 ambient = unity_AmbientSky;
                float diffuse = saturate(dot(lDir, nDir));
                diffuse = lerp(diffuse, 1, _Control);//uv图模式下直接才采样即可
                float fresnel = pow(1 - saturate(dot(nDir, vDir)), _FresnelPow);
                fresnel = lerp(fresnel, 0, _Control);//uv图模式下没有菲涅尔效果

                float3 finalRGB = (ambient + diffuse) * mainTex + fresnel;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}