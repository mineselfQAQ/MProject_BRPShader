Shader "MineselfShader/VFX/4-VertexAnimation/Shrink"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Range(0, 2)) = 1
        _Min("Min", Float) = -1
        _Max("Max", Float) = 1
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
            #include "..\..\..\_Common\MyLib.cginc"
			
            //变量申明
            sampler2D _MainTex; float4 _MainTex_ST;
            float _Speed;
            float _Min;
            float _Max;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
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

                //计算时间
                float t = sin(frac(_Time.y * _Speed) * UNITY_TWO_PI);
                t = Remap(t, -1, 1, _Min, _Max);//原本值域[-1,1]，这正好是默认位移的倍率，直接重映射即可
                //收缩的核心---沿法线方向移动一段距离
                v.vertex.xyz += v.normal * t;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}