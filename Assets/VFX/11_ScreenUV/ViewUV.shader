Shader "MineselfShader/VFX/11-ScreenUV/ViewUV"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Scale("Scale", vector) = (1,1,0,0)
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
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _MainTex;
            float2 _Scale;
                
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
                float2 screenUV : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //计算"屏幕"空间uv，也就是观察空间uv
                float3 vPos = UnityObjectToViewPos(v.vertex);
                //计算中vPos.z与pivotZ有所联系：
                //两者一乘一除解决了斜视角拉伸问题
                //如果只有pivotZ(删除vPos.z)，此时可以出现正远小近大的效果
                o.screenUV = vPos.xy / vPos.z;
                //***不应该添加***，会导致uv上下翻转
                //o.screenUV.y *= _ProjectionParams.x;
                float pivotZ = UnityObjectToViewPos(float3(0, 0, 0)).z;
                o.screenUV = o.screenUV * pivotZ * _Scale;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.screenUV);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}