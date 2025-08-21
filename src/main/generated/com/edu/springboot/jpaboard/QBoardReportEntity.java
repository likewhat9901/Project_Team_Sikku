package com.edu.springboot.jpaboard;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QBoardReportEntity is a Querydsl query type for BoardReportEntity
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QBoardReportEntity extends EntityPathBase<BoardReportEntity> {

    private static final long serialVersionUID = 228996420L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QBoardReportEntity boardReportEntity = new QBoardReportEntity("boardReportEntity");

    public final QBoardEntity board;

    public final NumberPath<Long> boardIdx = createNumber("boardIdx", Long.class);

    public final StringPath content = createString("content");

    public final DateTimePath<java.time.LocalDateTime> reportDate = createDateTime("reportDate", java.time.LocalDateTime.class);

    public final NumberPath<Long> reportIdx = createNumber("reportIdx", Long.class);

    public final StringPath userId = createString("userId");

    public QBoardReportEntity(String variable) {
        this(BoardReportEntity.class, forVariable(variable), INITS);
    }

    public QBoardReportEntity(Path<? extends BoardReportEntity> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QBoardReportEntity(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QBoardReportEntity(PathMetadata metadata, PathInits inits) {
        this(BoardReportEntity.class, metadata, inits);
    }

    public QBoardReportEntity(Class<? extends BoardReportEntity> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.board = inits.isInitialized("board") ? new QBoardEntity(forProperty("board")) : null;
    }

}

