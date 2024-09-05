Shader "MineselfShader/VFX/9-PolarCoord/Distort_Normal"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Range(0, 10)) = 1
        _Int("Intensity", Float) = 3
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
            #include "..\..\_Common\MyLib.cginc"
			
            //变量申明
            sampler2D _MainTex; float4 _MainTex_ST;
            float _Speed;
            float _Int;
                
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
                o.pos = UnityObjectToClipPos(v.vertex);

                //进行缩放操作，由于需要在贴图中心处缩放，所以需要先进行位移才行
                v.uv -= 0.5;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv += 0.5;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //移动uv至[-0.5,0.5]
                float2 uv = i.uv - float2(0.5, 0.5);

                //计算旋转角度---类似于极坐标版中的u
                float angle = frac(_Time.x * _Speed) * _Int / (length(uv) + 0.1);

                //旋转
                float2x2 rM = RotationMat(angle);
                uv = mul(rM, uv);

                //将uv移回
                uv += float2(0.5, 0.5);

                float4 mainTex = tex2D(_MainTex, uv);
                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}