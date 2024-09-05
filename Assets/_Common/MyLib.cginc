#ifndef MYLIB
#define MYLIB

//重映射
float Remap(float x, float inMin, float inMax, float outMin, float outMax)
{
    return (outMax - outMin) / (inMax - inMin) * (x - inMin) + outMin;
}
//随机数---取值范围[0,1]
//第一个数字为传入维度，第二个数字为输出维度，如Hash13()---传入1D，输出3D
float3 Hash23(float2 uv)
{
	float3 x = float3(uv.xyx);
	x = dot(x, float3(127.1, 311.7, 74.7));
	float3 y = float3(uv.yxx);
	y = dot(y, float3(269.5, 183.3, 246.1));
	float3 z = float3(uv.xyy);
	z = dot(z, float3(113.5, 271.9, 124.6));

	float3 ret = frac(sin(float3(x.x, y.x, z.x)) * 43758.5453123);

	return ret;
}



//RGB与HSV色彩空间的互相转换函数
float3 RGB2HSV(float3 c)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = lerp(float4(c.bg, K.wz),
					float4(c.gb, K.xy),
					step(c.b, c.g));
    float4 q = lerp(float4(p.xyw, c.r),
					float4(c.r, p.yzx),
					step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
				  d / (q.x + e),
				  q.x);
}
float3 HSV2RGB(float3 c)
{
    float3 rgb = clamp(abs(fmod(c.x * 6.0 + float3(0.0, 4.0, 2.0), 6.0) -3.0) - 1.0,
					   0.0, 1.0);
    rgb = rgb * rgb * (3.0 - 2.0 * rgb);//Cubic smoothing
    return c.z * lerp(float3(1,1,1), rgb, c.y);
}
float3 HSV2RYB(float3 c)
{
	//先将RGB映射为RYB
	float hue = fmod(c.x * 6, 6);
    if(hue >= 0 && hue <= 2)
        hue = 0.5 * hue;
    else if(hue > 2 && hue <= 3)
        hue = hue - 1;
    else if(hue > 3 && hue <= 4)
        hue = 1.5 * hue - 2.5;
    else if(hue > 4 && hue <= 5)
        hue = hue - 0.5;
    else if(hue > 5 && hue <= 6)
        hue = 1.5 * hue - 3;
    hue = hue * (1.0 / 6.0);
	//再转换
    float3 rgb = clamp(abs(fmod(hue * 6.0 + float3(0.0, 4.0, 2.0), 6.0) -3.0) - 1.0,
					   0.0,
					   1.0);
    rgb = rgb * rgb * (3.0 - 2.0 * rgb);//Cubic smoothing
    return c.z * lerp(float3(1,1,1), rgb, c.y);
}
//角度Degree与弧度Radian的互相转换函数
float Deg2Rad(float angle)
{
	return angle * UNITY_PI / 180.0f;
}
float Rad2Deg(float rad)
{
	return rad * (180.0f / UNITY_PI);
}



//创建旋转矩阵
float2x2 RotationMat(float rad)
{
	float2x2 rM = float2x2(cos(rad), -sin(rad),
						   sin(rad), cos(rad));
	return rM;
}
//UV变换---要注意:这里的平移会根据旋转后的方向移动
float2 UVTransform(float2 uv, float2 scale, float rotation, float2 offset, float2 pivot)
{
	//轴心点
	uv -= pivot;
	//先缩放
	uv *= scale;
	//再旋转
	float2x2 rM = RotationMat(rotation);
	uv = mul(rM, uv);
	//最后平移
	uv -= offset;
	//移回原处
	uv += pivot;

	return uv;
}
float2 UVTransform(float2 uv, float2 scale, float rotation, float2 offset)
{
	//默认情况，选择(0.5,0.5)点作为旋转中心进行旋转

	uv -= float2(0.5, 0.5);//中心旋转
	//先缩放
	uv *= scale;
	//再旋转
	float2x2 rM = RotationMat(rotation);
	uv = mul(rM, uv);
	//最后平移
	uv -= offset;
	uv += float2(0.5, 0.5);//中心旋转

	return uv;
}
float2 RandomUVTransform(float2 uv, float2 scaleMinMax, float2 rotationMinMax, float2 randomSeed)
{
	//求3个随机值，随机值范围[0,1]
	float3 random = Hash23(randomSeed);

	//随机平移值
	float2 offset = random.xy;
	//随机旋转值
	//使用了*16后frac()的方法得到了另一个随机值
	//原本值的取值范围为[0,1]，*16后为[0,16]，进行frac()后大概率能得到一个与前面不同的随机值
	float rotation = lerp(rotationMinMax.x, rotationMinMax.y, frac(random.z * 16));
	rotation = Deg2Rad(rotation);
	//随机缩放值
	float2 scale = lerp(scaleMinMax.x, scaleMinMax.y, random.z);

	return UVTransform(uv, scale, rotation, offset, float2(0.5, 0.5));
}

//直角坐标系转极坐标系
//输入---(uv，原点)    输出---(角度，半径)
//如果传入的是正常uv，最终输出的是：
//theta---以x轴正半轴为初始逆时针旋转，范围[0,1]
//r---最大圆半径1
float2 Rect2Polar(float2 uv, float2 pivot) 
{
    uv = uv - pivot;//uv默认取值范围[0,1]，正常来说我们需要的是[-0.5,0.5]，所以pivot正常来说会取(0.5,0.5)
    float theta = atan2(uv.y, uv.x);// atan()值域[-π/2, π/2]一般不用，atan2()值域[-π, π]
	theta = frac(theta / UNITY_TWO_PI);//映射成以x轴正半轴为初始逆时针旋转，范围[0,1]
    float r = length(uv);
	r *= 2;//将其从最大圆半径为0.5映射至1

    return float2(theta, r);
}

//Billboard效果
//使用方法---直接传入v.vertex，将获得的结果放入UnityObjectToClipPos()中
float3 Billboard(float4 v)
{
	//计算前向量
	float3 forwardDir = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;
	forwardDir = normalize(forwardDir);

	//计算临时上向量--->右向量--->上向量
	float3 upDir = abs(forwardDir.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
	float3 rightDir = normalize(cross(forwardDir, upDir));
	upDir = normalize(cross(rightDir, forwardDir));

	//物体空间的Billboard的核心---变换顶点位置使其对齐视角
	float3x3 rotationMat = float3x3(rightDir, upDir, -forwardDir);
	float3 vertex = mul(transpose(rotationMat), v.xyz);

	return vertex;
}
float3 Billboard_cylindrical(float4 v)//特殊情况---限制上下向不动，只能左右向跟随
{
	//计算前向量
	float3 forwardDir = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;
	forwardDir.y = 0;
	forwardDir = normalize(forwardDir);

	//计算临时上向量--->右向量--->上向量
	float3 upDir = abs(forwardDir.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
	float3 rightDir = normalize(cross(forwardDir, upDir));
	upDir = normalize(cross(rightDir, forwardDir));

	//物体空间的Billboard的核心---变换顶点位置使其对齐视角
	float3x3 rotationMat = float3x3(rightDir, upDir, -forwardDir);
	float3 vertex = mul(transpose(rotationMat), v.xyz);

	return vertex;
}

//图形绘制
//3.圆		需要正常的[0,1]uv		注意：函数中已经将中心点已经移到(0.5,0.5)
float DrawCircle(float2 uv, float r, float blur)
{
	//这里将其默认映射到[-0.5,0.5]，也就是原点设置为(0.5,0.5)
	float2 dist = uv - float2(0.5, 0.5);

	//注意：这里dot()要乘4，因为dot()的结果取值范围为[0,0.25]，需要映射为[0,1]
	//因为前面的dist进行的是位移操作，所以这里的倍率是不会有影响的
	float finalMask = 1 - smoothstep(r - (r * blur),
									 r + (r * blur),
									 dot(dist, dist) * 4);
	return finalMask;
}
float DrawCircle(float2 uv, float r, float2 center, float blur)
{
    //uv需要位移，或者说将uv从[0,1]映射到[-center,1-center]
	//这里将其默认映射到[-0.5,0.5]，也就是原点设置为(0.5,0.5)
	float2 dist = uv - center;

	//注意：这里dot()要乘4，因为dot()的结果取值范围为[0,0.25]，需要映射为[0,1]
	//因为前面的dist进行的是位移操作，所以这里的倍率是不会有影响的
	float finalMask = 1 - smoothstep(r - (r * blur),
									 r + (r * blur),
									 dot(dist, dist) * 4);
	return finalMask;
}

//***
//计算边缘---使用深度图
//注意：交界处为0，越远值越大
//***
float ComputeEdge(float4 screenPos, sampler2D cameraDepthTexture, float edgeWidth)
{
	//求观察空间线性深度值
    float screenZRaw = SAMPLE_DEPTH_TEXTURE_PROJ(cameraDepthTexture, UNITY_PROJ_COORD(screenPos)).r;
    float eyeZLinear = LinearEyeDepth(screenZRaw);

    //求边缘
    //其中，i.screenPos.w---指的是裁剪空间物体线性深度值
    //所以两者相减能得到边缘0，两者差越大值越大的一个遮罩
    float edgeMask = saturate((eyeZLinear - screenPos.w) / edgeWidth);

	return edgeMask;
}

//***
//法线混合
//***
//Linear
float3 normalBlend_linear(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = n1 + n2;
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//Common
float3 normalBlend_common(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = float3(n1.xy + n2.xy, 1);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//PD
float3 normalBlend_pd(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = float3(n1.xy * n2.z + n2.xy * n1.z, n1.z * n2.z);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//UDN
float3 normalBlend_udn(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = float3(n1.xy + n2.xy, n1.z);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//Whiteout
float3 normalBlend_whiteout(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = float3(n1.xy + n2.xy , n1.z * n2.z);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//RNM
float3 normalBlend_rnm(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    n1.z += 1;
    n2.xy *= -1;
    float3 blendNormal = dot(n1, n2) * n1 - n2 * n1.z;
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//Unity
float3 normalBlend_unity(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float4 n1 = float4(UnpackNormal(tex2D(t1, uv * s1)), 0);
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    n1.w = -n1.z;
    float3 blendNormal;
    blendNormal.x = dot(n1.zxx, n2.xyz);
    blendNormal.y = dot(n1.yzy, n2.xyz);
    blendNormal.z = dot(n1.xyw, -n2.xyz);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}


#endif