package com.edu.springboot.jpaboard;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QBoardImageEntity is a Querydsl query type for BoardImageEntity
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QBoardImageEntity extends EntityPathBase<BoardImageEntity> {

    private static final long serialVersionUID = 1631546481L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QBoardImageEntity boardImageEntity = new QBoardImageEntity("boardImageEntity");

    public final QBoardEntity board;

    public final StringPath filePath = createString("filePath");

    public final NumberPath<Long> imageIdx = createNumber("imageIdx", Long.class);

    public final StringPath originalName = createString("originalName");

    public final StringPath savedName = createString("savedName");

    public QBoardImageEntity(String variable) {
        this(BoardImageEntity.class, forVariable(variable), INITS);
    }

    public QBoardImageEntity(Path<? extends BoardImageEntity> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QBoardImageEntity(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QBoardImageEntity(PathMetadata metadata, PathInits inits) {
        this(BoardImageEntity.class, metadata, inits);
    }

    public QBoardImageEntity(Class<? extends BoardImageEntity> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.board = inits.isInitialized("board") ? new QBoardEntity(forProperty("board")) : null;
    }

}

