Shader "MineselfShader/VFX/7-SquenceAnimation/SequenceAnimation"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Row("Row", Float) = 0
        _Column("Column", Float) = 0
        _Speed("Speed", Range(0, 2)) = 1
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _MainTex;
            float _Row;
            float _Column;
            float _Speed;
                
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

                //计算时间
                float t = floor(frac(_Time.y * _Speed) * _Row * _Column);

                //计算当前行列
                float row = floor(t / _Column);//执行完一行中的所有内容(n列)后执行下一行
                float column = fmod(t, _Column);//执行完一格后执行第二格

                //计算当前采样uv
                //这样思考比较好理解：
                //uv每个轴向的取值范围为[0,1]，先要考虑当前所在的位置，
                //比如说第二列，那么就是[1,2]，此时再除以列数得到在[0,1]之间的内容
                float U = (v.uv.x + column) / _Column;
                float V = (v.uv.y - 1 - row) / _Row;//uv需要向下移动一格才是将左上角设为初始

                o.uv = float2(U, V);

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