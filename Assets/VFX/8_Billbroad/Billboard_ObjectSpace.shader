Shader "MineselfShader/VFX/8-Billboard/Billboard_ObjectSpace"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [HDR]_Color("Color", COLOR) = (1,1,1,1)
        [KeywordEnum(Spherical, Cylindrical)]_Type("Type", Float) = 0
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
            "DisableBatching"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令
            #pragma shader_feature _TYPE_SPHERICAL _TYPE_CYLINDRICAL
			
            //变量申明
            sampler2D _MainTex;
            fixed4 _Color;

                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;

                //计算前向量
                float3 forwardDir = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;
                //处理特殊情况---只跟随左右，不跟随上下
                #if _TYPE_CYLINDRICAL
                    forwardDir.y = 0;
                #endif
                	forwardDir = normalize(forwardDir);

                //计算临时上向量--->右向量--->上向量
                float3 upDir = abs(forwardDir.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
                float3 rightDir = normalize(cross(forwardDir, upDir));
                upDir = normalize(cross(rightDir, forwardDir));

                //物体空间的Billboard的核心---变换顶点位置使其对齐视角
                float3x3 rotationMat = float3x3(rightDir, upDir, -forwardDir);
                float3 vertex = mul(transpose(rotationMat), v.vertex);

                o.pos = UnityObjectToClipPos(vertex);

                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                mainTex.rgb *= _Color;

                clip(mainTex.a - 0.5);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}