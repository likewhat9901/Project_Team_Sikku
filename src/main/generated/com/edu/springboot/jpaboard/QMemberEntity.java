package com.edu.springboot.jpaboard;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QMemberEntity is a Querydsl query type for MemberEntity
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QMemberEntity extends EntityPathBase<MemberEntity> {

    private static final long serialVersionUID = -1191081546L;

    public static final QMemberEntity memberEntity = new QMemberEntity("memberEntity");

    public final StringPath address = createString("address");

    public final StringPath authority = createString("authority");

    public final StringPath email = createString("email");

    public final NumberPath<Integer> enabled = createNumber("enabled", Integer.class);

    public final StringPath phonenumber = createString("phonenumber");

    public final StringPath userId = createString("userId");

    public final StringPath username = createString("username");

    public final StringPath userpw = createString("userpw");

    public QMemberEntity(String variable) {
        super(MemberEntity.class, forVariable(variable));
    }

    public QMemberEntity(Path<? extends MemberEntity> path) {
        super(path.getType(), path.getMetadata());
    }

    public QMemberEntity(PathMetadata metadata) {
        super(MemberEntity.class, metadata);
    }

}

